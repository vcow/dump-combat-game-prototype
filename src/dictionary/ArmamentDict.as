package dictionary
{
	import vo.AmmoDescVO;
	import vo.ArmorDescVO;
	import vo.ResourceDescVO;
	import vo.WeaponDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека оружия и брони
	 * 
	 */
	
	public final class ArmamentDist
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/armament.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:ArmamentDist;
        
        private var _weapons:Vector.<WeaponDescVO>;
        private var _ammos:Vector.<AmmoDescVO>;
        private var _armors:Vector.<ArmorDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function ArmamentDist()
        {
            if (_instance != null)
                throw Error("ArmamentDist is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():ArmamentDist
		{
			if (!_instance)
				_instance = new ArmamentDist();
			return _instance;
		}
		
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function init():void
        {
			if (!_weapons && !_ammos && !_armors)
			{
                _weapons = new Vector.<WeaponDescVO>();
                _ammos = new Vector.<AmmoDescVO>();
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
                    _ammos.push(ammo);
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