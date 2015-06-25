package vo
{
    import helpers.TimeHelper;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object описания события
	 * 
	 */
	
	public class EventDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "eventDesc";
        
        public static const SEC:String = "sec";
        public static const MIN:String = "min";
        public static const ARTIFACT_FOUND:String = "artifactFound";
        public static const BATTLE_COMPLETED:String = "battleCompleted";
        public static const RESEARCH_COMPLETED:String = "reseachCompleted";
        public static const PRODUCTION_COMPLETED:String = "productionCompleted";
        public static const PAY_DAY:String = "payDay";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var eventId:String;				//< Идентификатор события
		public var eventInterval:Number;        //< Временной интервал срабатывания события
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EventDescVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = eventId;
            if (!isNaN(eventInterval))
                res.@interval = new TimeHelper().timeToStr(eventInterval);
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            eventId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            eventInterval = data.hasOwnProperty("@interval") ? parseFloat(data.@interval.toString()) : NaN;
			
			// /TODO
			
			return true;
		}
	}
}