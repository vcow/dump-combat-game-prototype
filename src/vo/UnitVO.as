package vo
{
    import dictionary.Const;
    import dictionary.UnitsDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object юнита
	 * 
	 */
	
	public class UnitVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "unit";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var unitId:String;                                       //< Уникальный идентификатор юнита
        public var unitName:String;                                     //< Имя юнита
        public var unitCrew:Vector.<String> = new Vector.<String>();    //< Список идентификаторов солдат в команде
        public var unitDamage:Number;                                   //< Процент повреждения юнита
		
        private var _unitUnitId:String;
        private var _unitDesc:UnitDescVO;
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function UnitVO()
		{
			super(NAME);
		}
        
        /**
         * Идентификатор описания юнита
         */
        public function set unitUnitId(value:String):void
        {
            if (value == _unitUnitId)
                return;
            
            _unitUnitId = value;
            _unitDesc = UnitsDict.getInstance().getUnit(_unitUnitId);
        }
        
        public function get unitUnitId():String
        {
            return _unitUnitId;
        }
        
        /**
         * Описание юнита
         */
        public function get unitDesc():UnitDescVO
        {
            return _unitDesc;
        }
        
        /**
         * Оружие на юните
         */
        public function get unitWeapon():Vector.<WeaponVO>
        {
            var res:Vector.<WeaponVO> = new Vector.<WeaponVO>();
            for each (var item:IVO in children)
            {
                if (item.name == WeaponVO.NAME)
                    res.push(WeaponVO(item));
            }
            res.sort(sortWeapon);
            return res;
        }
        
        private function sortWeapon(a:WeaponVO, b:WeaponVO):Number
        {
            if (a.weaponSlot[0] > b.weaponSlot[0]) return 1;
            if (a.weaponSlot[0] < b.weaponSlot[0]) return -1;
            return 0;
        }
        
        /**
         * Броня на юните
         */
        public function get unitArmor():Vector.<ArmorVO>
        {
            var res:Vector.<ArmorVO> = new Vector.<ArmorVO>();
            for each (var item:IVO in children)
            {
                if (item.name == ArmorVO.NAME)
                    res.push(ArmorVO(item));
            }
            res.sort(sortArmor);
            return res;
        }
        
        private function sortArmor(a:ArmorVO, b:ArmorVO):Number
        {
            if (a.armorSlot[0] > b.armorSlot[0]) return 1;
            if (a.armorSlot[0] < b.armorSlot[0]) return -1;
            return 0;
        }
        
        /**
         * Заряженные снаряды
         */
        public function get unitAmmo():Vector.<AmmoVO>
        {
            var res:Vector.<AmmoVO> = new Vector.<AmmoVO>();
            for each (var item:IVO in children)
            {
                if (item.name == AmmoVO.NAME)
                    res.push(AmmoVO(item));
            }
            return res;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = unitId || VO.createGUID();
            res.@name = unitName;
            res.@unit = unitUnitId;
            res.@damage = isNaN(unitDamage) ? 0 : unitDamage;
            
            if (unitCrew && unitCrew.length > 0)
                res.@crew = unitCrew.join(",");
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            unitId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            unitName = data.hasOwnProperty("@name") ? data.@name.toString() : "";
            unitUnitId = data.hasOwnProperty("@unit") ? data.@unit.toString() : "";
            unitDamage = data.hasOwnProperty("@damage") ? Number(data.@damage) : 0;
			
            var crewList:Array = data.hasOwnProperty("@crew") ? data.@crew.toString().split(/\s*,\s*/) : [];
            unitCrew.splice(0, unitCrew.length);
            for each (var soldier:String in crewList)
                unitCrew.push(soldier);
            
			// /TODO
			
			return true;
		}
	}
}