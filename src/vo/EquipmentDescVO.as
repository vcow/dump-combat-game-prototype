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
        public var equipmentSlot:Vector.<int> = new Vector.<int>();         //< Список слотов, в которые помещается оборудование
		
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
            
            if (equipmentSlot.length > 0)
                res.@slot = equipmentSlot.join(",");
            
            if (equipmentUnit.length > 0)
                res.@unit = equipmentUnit.join(",");
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            equipmentId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            equipmentResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            
            var itemList:Array = data.hasOwnProperty("@slot") ? data.@slot.toString().split(/\s*,\s*/) : [];
            equipmentSlot.splice(0, equipmentSlot.length);
            for each (var item:String in itemList)
            {
                if (!isNaN(parseInt(item)))
                    equipmentSlot.push(int(item));
            }
            
            itemList = data.hasOwnProperty("@unit") ? data.@unit.toString().split(/\s*,\s*/) : [];
            equipmentUnit.splice(0, equipmentUnit.length);
            for each (item in itemList)
                equipmentUnit.push(item);
            
			// /TODO
			
			return true;
		}
	}
}