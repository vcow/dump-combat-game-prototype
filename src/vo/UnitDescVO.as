package vo
{
	import dictionary.Const;
	import dictionary.ResourcesDict;

    [ResourceBundle("units")]
    
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object юнита
	 * 
	 */
	
	public class UnitDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "unitDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var unitId:String;                   //< Уникальный идентификатор
        public var unitName:String;                 //< Наименование юнита
        public var unitDescription:String;          //< Описание юнита
        public var unitCrew:int;                    //< Количество солдат в экипаже
        public var unitSelfDestruct:int;            //< Количество атак до самоуничтожения юнита
        public var unitWeaponSlots:int;             //< Слотов под оружие
        public var unitArmorSlots:int;              //< Слотов под броню
        public var unitClip:int;                    //< Количество заряжаемых снарядов
        public var unitRecoveryEvent:String;        //< Событие, по которому происходит восстановление поврежденного юнита
		
		private var _unitResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function UnitDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set unitResource(value:String):void
		{
			if (value == _unitResource)
				return;
			
            _unitResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_unitResource);
		}
		
		public function get unitResource():String
		{
			return _unitResource;
		}
		
        /**
         * Описание соответствующего ресурса
         */
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
		}
        
        /**
         * Условие, при котором юнит может быть создан
         */
        public function get unitCondition():Object
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
			
            res.@id = unitId;
            res.@name = unitName;
            res.@description = unitDescription;
            res.@crew = unitCrew;
            res.@resource = unitResource;
            res.@weaponSlots = unitWeaponSlots;
            res.@armorSlots = unitArmorSlots;
            res.@recoveryEvent = unitRecoveryEvent;
            res.@clip = unitClip;
            
            if (unitSelfDestruct > 0)
                res.@selfDestruct = unitSelfDestruct;
            
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            unitId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            unitName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "units") : Const.NO_TEXT;
            unitDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "units") : Const.NO_TEXT;
            unitCrew = data.hasOwnProperty("@crew") ? int(data.@crew) : 0;
            unitResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            unitSelfDestruct = data.hasOwnProperty("@selfDestruct") ? int(data.@selfDestruct) : 0;
            unitWeaponSlots = data.hasOwnProperty("@weaponSlots") ? int(data.@weaponSlots) : 0;
            unitArmorSlots = data.hasOwnProperty("@armorSlots") ? int(data.@armorSlots) : 0;
            unitRecoveryEvent = data.hasOwnProperty("@recoveryEvent") ? data.@recoveryEvent.toString() : EventDescVO.DEFAULT_RECOVER_EVENT;
            unitClip = data.hasOwnProperty("@clip") ? int(data.@clip) : 0;
			
			// /TODO
			
			return true;
		}
	}
}