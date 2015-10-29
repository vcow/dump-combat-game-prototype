package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object снаряда
	 * 
	 */
	
	public class AmmoDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ammoDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var ammoId:String;                                       //< Уникальный идентификатор
        public var ammoUnit:Vector.<String> = new Vector.<String>();    //< Список оружия, для которого годится снаряд
		
		private var _ammoResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function AmmoDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set ammoResource(value:String):void
		{
			if (value == _ammoResource)
				return;
			
            _ammoResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_ammoResource);
		}
		
		public function get ammoResource():String
		{
			return _ammoResource;
		}
		
        /**
         * Описание соответствующего ресурса
         */
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
		}
        
        /**
         * Условие, при котором снаряд может быть использован
         */
        public function get ammoCondition():Object
        {
            for each (var item:IVO in children)
            {
                if (item.name == ConditionVO.NAME)
                    return ConditionVO(item).conditionData;
            }
            return null;
        }
        
        /**
         * Модификаторы
         */
        public function get ammoModifiers():ModifiersVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ModifiersVO.NAME)
                    return item as ModifiersVO;
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
			
            res.@id = ammoId;
            res.@resource = ammoResource;
            
            if (ammoUnit.length > 0)
                res.@unit = ammoUnit.join(",");
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            ammoId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            ammoResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            
            var unitList:Array = data.hasOwnProperty("@unit") ? data.@unit.toString().split(/\s*,\s*/) : [];
            ammoUnit.splice(0, ammoUnit.length);
            for each (var unit:String in unitList)
                ammoUnit.push(unit);
            
			// /TODO
			
			return true;
		}
	}
}