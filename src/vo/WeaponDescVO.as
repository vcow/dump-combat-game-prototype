package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object оружия
	 * 
	 */
	
	public class WeaponDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "weaponDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var weaponId:String;                                     //< Уникальный идентификатор
        public var weaponUnit:Vector.<String> = new Vector.<String>();  //< Список юнитов, для которого годится оружие
        public var weaponSlot:Vector.<int> = new Vector.<int>();        //< Список слотов, в которые помещается оружие
        public var weaponClip:int;                                      //< Количество зарядов в обойме
		
		private var _weaponResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function WeaponDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set weaponResource(value:String):void
		{
			if (value == _weaponResource)
				return;
			
            _weaponResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_weaponResource);
		}
		
		public function get weaponResource():String
		{
			return _weaponResource;
		}
		
        /**
         * Описание соответствующего ресурса
         */
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
		}
        
        /**
         * Условие, при котором оружие может быть использовано
         */
        public function get weaponCondition():Object
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
        public function get weaponModifiers():ModifiersVO
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
			
            res.@id = weaponId;
            res.@resource = weaponResource;
            
            if (weaponSlot.length > 0)
                res.@slot = weaponSlot.join(",");
            
            if (weaponUnit.length > 0)
                res.@unit = weaponUnit.join(",");
            
            if (weaponClip)
                res.@clip = weaponClip;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            weaponId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            weaponResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            weaponClip = data.hasOwnProperty("@clip") ? int(data.@clip) : 0;
            
            var itemList:Array = data.hasOwnProperty("@slot") ? data.@slot.toString().split(/\s*,\s*/) : [];
            weaponSlot.splice(0, weaponSlot.length);
            for each (var item:String in itemList)
            {
                if (!isNaN(parseInt(item)))
                    weaponSlot.push(int(item));
            }
            
            itemList = data.hasOwnProperty("@unit") ? data.@unit.toString().split(/\s*,\s*/) : [];
            weaponUnit.splice(0, weaponUnit.length);
            for each (item in itemList)
                weaponUnit.push(item);
			
			// /TODO
			
			return true;
		}
	}
}