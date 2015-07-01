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
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var eventId:String;				//< Идентификатор события
		public var eventInterval:Number;        //< Временной интервал срабатывания события
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EventDescVO()
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
            eventInterval = data.hasOwnProperty("@interval") ? (new TimeHelper).strToTime(data.@interval.toString()) : NaN;
			
			// /TODO
			
			return true;
		}
	}
}