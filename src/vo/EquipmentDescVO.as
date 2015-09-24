package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object оборудования
	 * 
	 */
	
	public class EquipmentDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "equipmentDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var equipmentId:String;                                      //< Уникальный идентификатор
        public var equipmentUnit:Vector.<String> = new Vector.<String>();   //< Список юнитов, для которого годится оборудование
		
		private var _equipmentResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EquipmentDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set equipmentResource(value:String):void
		{
			if (value == _equipmentResource)
				return;
			
            _equipmentResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_equipmentResource);
		}
		
		public function get equipmentResource():String
		{
			return _equipmentResource;
		}
		
        /**
         * Описание соответствующего ресурса
         */
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
		}
        
        /**
         * Условие, при котором оборудование может быть использовано
         */
        public function get equipmentCondition():Object
        {
            for each (var item:IVO in children)
            {
                if (item.name == ConditionVO.NAME)
                    return ConditionVO(item).conditionData;
            }
            return null;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = equipmentId;
            res.@resource = equipmentResource;
            
            if (equipmentUnit.length > 0)
                res.@unit = equipmentUnit.join(",");
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
			
            equipmentId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            equipmentResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            
            var unitList:Array = data.hasOwnProperty("@unit") ? data.@unit.toString().split(/\s*,\s*/) : [];
            equipmentUnit.splice(0, equipmentUnit.length);
            for each (var unit:String in unitList)
                equipmentUnit.push(unit);
            
            for each (var sub:XML in data.child(ConditionVO.NAME))
            {
                var condition:ConditionVO = new ConditionVO();
                condition.deserialize(sub);
                children.push(condition);
            }
            delete data[ConditionVO.NAME];
            
            _data = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}