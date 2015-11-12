package vo
{
    import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object военного рейда
	 * 
	 */
	
	public class RaidVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "raid";
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var raidId:String;                   //< Идентификатор рейда
        public var raidTarget:String;               //< База, на которую происходит нападение
        public var raidTargetOwner:String;          //< Идентификатор владельца базы, на которую происходит нападение
        public var raidDeparture:String;            //< База, c которой происходит нападение
        public var raidDepartureOwner:String;       //< Идентификатор владельца базы, с которой происходит нападение
        public var raidTimer:String;                //< Идентификатор таймера до момента сражения
        public var raidDelayed:Boolean;             //< Флаг, указывающий на то, что рейд находится в состоянии ожидания решения
        public var raidVictorious:Boolean;          //< Флаг, указывающий, что рейд был успешным
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function RaidVO()
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
			
			res.@id = raidId || VO.createGUID();
            res.@target = raidTarget;
            res.@departure = raidDeparture;
            
            if (raidTargetOwner)
                res.@targetOwner = raidTargetOwner;
            
            if (raidDepartureOwner)
                res.@departureOwner = raidDepartureOwner;
            
            if (raidTimer)
                res.@timer = raidTimer;
            
            if (raidVictorious)
                res.@victorious = raidVictorious;
            
            if (raidDelayed)
                res.@delayed = raidDelayed;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            raidId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            raidTarget = data.hasOwnProperty("@target") ? data.@target.toString() : Const.NO_GUID;
            raidTargetOwner = data.hasOwnProperty("@targetOwner") ? data.@targetOwner.toString() : "";
            raidDeparture = data.hasOwnProperty("@departure") ? data.@departure.toString() : Const.NO_GUID;
            raidDepartureOwner = data.hasOwnProperty("@departureOwner") ? data.@departureOwner.toString() : "";
            raidTimer = data.hasOwnProperty("@timer") ? data.@timer.toString() : "";
            raidVictorious = data.hasOwnProperty("@victorious") ? data.@victorious.toString().toLowerCase() == "true" : false;
            raidDelayed = data.hasOwnProperty("@delayed") ? data.@delayed.toString().toLowerCase() == "true" : false;
			
			// /TODO
			
			return true;
		}
	}
}