package vo
{
    import dictionary.ArmamentDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object снаряженного заряда
	 * 
	 */
	
	public class AmmoVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ammo";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        private var _ammoId:String;
        private var _ammoDesc:AmmoDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function AmmoVO()
		{
			super(NAME);
		}
        
        /**
         * Идентификатор оружия
         */
        public function set ammoId(value:String):void
        {
            if (value == _ammoId)
                return;
            
            _ammoId = value;
            _ammoDesc = ArmamentDict.getInstance().getAmmo(_ammoId);
        }
        
        public function get ammoId():String
        {
            return _ammoId;
        }
        
        public function get ammoDesc():AmmoDescVO
        {
            return _ammoDesc;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = ammoId;
            
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            ammoId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}
	