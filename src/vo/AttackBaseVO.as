package vo
{
    import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object нападения на базу
	 * 
	 */
	
	public class AttackBaseVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "attackBase";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var attackBaseTarget:String;         //< Идентификатор базы, на которую происходит нападение
        public var attackBaseDeparture:String;      //< Идентификатор базы, с которой происходит нападение
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
		public function AttackBaseVO()
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
            
            res.@target = attackBaseTarget;
            res.@departure = attackBaseDeparture;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            attackBaseTarget = data.hasOwnProperty("@target") ? data.@target.toString() : Const.NO_GUID;
            attackBaseDeparture = data.hasOwnProperty("@departure") ? data.@departure.toString() : Const.NO_GUID;
            
            // /TODO
            
            return true;
        }
	}
}