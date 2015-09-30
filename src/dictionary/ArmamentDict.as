package dictionary
{
	import vo.AmmoDescVO;
	import vo.ArmorDescVO;
	import vo.WeaponDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека оружия и брони
	 * 
	 */
	
	public final class ArmamentDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/armament.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:ArmamentDict;
        
        private var _weapons:Vector.<WeaponDescVO>;
        private var _ammo:Vector.<AmmoDescVO>;
        private var _armors:Vector.<ArmorDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function ArmamentDict()
        {
            if (_instance != null)
                throw Error("ArmamentDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():ArmamentDict
		{
			if (!_instance)
				_instance = new ArmamentDict();
			return _instance;
		}
        
        /**
         * Получить все оружие, совместимое с указанным юнитом
         * @param unitId идентификатор юнита
         * @return список оружия
         */
        public function getWeaponForUnit(unitId:String):Vector.<WeaponDescVO>
        {
            init();
            
            var res:Vector.<WeaponDescVO> = new Vector.<WeaponDescVO>();
            for each (var weapon:WeaponDescVO in _weapons)
            {
                for each (var id:String in weapon.weaponUnit)
                {
                    if (id == unitId)
                    {
                        res.push(weapon);
                        break;
                    }
                }
            }
            return res;
        }
        
        /**
         * Получить оружие по его идентификатору
         * @param weaponId идентификатор оружия
         * @return описание оружия
         */
        public function getWeapon(weaponId:String):WeaponDescVO
        {
            init();
            
            for each (var weapon:WeaponDescVO in _weapons)
            {
                if (weapon.weaponId == weaponId)
                    return weapon;
            }
            
            return null;
        }
        
        /**
         * Получить броню по ее идентификатору
         * @param weaponId идентификатор брони
         * @return описание брони
         */
        public function getArmor(armorId:String):ArmorDescVO
        {
            init();
            
            for each (var armor:ArmorDescVO in _armors)
            {
                if (armor.armorId == armorId)
                    return armor;
            }
            
            return null;
        }
        
        /**
         * Получить снаряд по его идентификатору
         * @param ammoId идентификатор снаряда
         * @return описание снаряда
         */
        public function getAmmo(ammoId:String):AmmoDescVO
        {
            init();
            
            for each (var ammo:AmmoDescVO in _ammo)
            {
                if (ammo.ammoId == ammoId)
                    return ammo;
            }
            
            return null;
        }
        
        /**
         * Получить снаряд по идентификатору его ресурса
         * @param resourceId идентификатор ресурса
         * @return описание снаряда
         */
        public function getAmmoByResource(resourceId:String):AmmoDescVO
        {
            init();
            
            for each (var ammo:AmmoDescVO in _ammo)
            {
                if (ammo.ammoResource == resourceId)
                    return ammo;
            }
            
            return null;
        }
        
        /**
         * Получить всю броню, совместимую с указанным юнитом
         * @param unitId идентификатор юнита
         * @return список брони
         */
        public function getArmorForUnit(unitId:String):Vector.<ArmorDescVO>
        {
            init();
            
            var res:Vector.<ArmorDescVO> = new Vector.<ArmorDescVO>();
            for each (var armor:ArmorDescVO in _armors)
            {
                for each (var id:String in armor.armorUnit)
                {
                    if (id == unitId)
                    {
                        res.push(armor);
                        break;
                    }
                }
            }
            return res;
        }
        
        /**
         * Получить все снаряды, совместимые с указанным юнитом
         * @param unitId идентификатор юнита
         * @return список снарядов
         */
        public function getAmmoForUnit(unitId:String):Vector.<AmmoDescVO>
        {
            init();
            
            var res:Vector.<AmmoDescVO> = new Vector.<AmmoDescVO>();
            for each (var ammo:AmmoDescVO in _ammo)
            {
                for each (var id:String in ammo.ammoUnit)
                {
                    if (id == unitId)
                    {
                        res.push(ammo);
                        break;
                    }
                }
            }
            return res;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function init():void
        {
			if (!_weapons && !_ammo && !_armors)
			{
                _weapons = new Vector.<WeaponDescVO>();
                _ammo = new Vector.<AmmoDescVO>();
                _armors = new Vector.<ArmorDescVO>();
				
				var src:XML = XML(new source());
                
				var items:XMLList = src.child(WeaponDescVO.NAME);
				for each (var item:XML in items)
				{
					var weapon:WeaponDescVO = new WeaponDescVO();
                    weapon.deserialize(item);
                    _weapons.push(weapon);
				}
                
                items = src.child(AmmoDescVO.NAME);
                for each (item in items)
                {
                    var ammo:AmmoDescVO = new AmmoDescVO();
                    ammo.deserialize(item);
                    _ammo.push(ammo);
                }
                
                items = src.child(ArmorDescVO.NAME);
                for each (item in items)
                {
                    var armor:ArmorDescVO = new ArmorDescVO();
                    armor.deserialize(item);
                    _armors.push(armor);
                }
			}
		}
	}
}