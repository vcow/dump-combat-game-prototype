package vo
{
    import dictionary.ArmamentDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object надетого оружия
	 * 
	 */
	
	public class WeaponVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "weapon";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public var weaponSlot:int;                  //< Номер слота оружия
		
        private var _weaponId:String;
        private var _weaponDesc:WeaponDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function WeaponVO()
		{
			super(NAME);
		}
        
        /**
         * Идентификатор оружия
         */
        public function set weaponId(value:String):void
        {
            if (value == _weaponId)
                return;
            
            _weaponId = value;
            _weaponDesc = ArmamentDict.getInstance().getWeapon(_weaponId);
        }
        
        public function get weaponId():String
        {
            return _weaponId;
        }
        
        public function get weaponDesc():WeaponDescVO
        {
            return _weaponDesc;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = weaponId;
            res.@slot = weaponSlot;
            
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            weaponId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            weaponSlot = data.hasOwnProperty("@slot") ? int(data.@slot) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	