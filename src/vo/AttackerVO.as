package vo
{
    import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object атакующего юнита
	 * 
	 */
	
	public class AttackerVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "attacker";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var attackerId:String;       //< Идентификатор атакующего юнита
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
		public function AttackerVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            var res:XML = super.getSelfXMLObject();
            
            // TODO: Сериализовать специфичные поля
            
            res.@id = attackerId;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            attackerId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            
            // /TODO
            
            return true;
        }
	}
}