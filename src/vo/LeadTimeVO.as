package vo
{
	import helpers.TimeHelper;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object времени создания
	 * 
	 */
	
	public class LeadTimeVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "leadTime";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var leadTimeTime:Number;             //< Время
        public var leadTimeEvent:String;            //< Внутриигровое событие, генерирующееся по завершению таймера
        public var leadTimeNotification:String;     //< Нотификация, отправляемая по завершению таймера
        public var leadTimeData:Object;             //< Дополнительные параметры для нотификации
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function LeadTimeVO()
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
			
			res.@time = (new TimeHelper()).timeToStr(leadTimeTime);
            
            if (leadTimeEvent)
                res.@event = leadTimeEvent;
            
            if (leadTimeNotification)
                res.@notification = leadTimeNotification;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			
			// TODO: десериализовать специфичные поля
			
            leadTimeTime = data.hasOwnProperty("@time") ? (new TimeHelper()).strToTime(data.@time.toString()) : 0;
            leadTimeEvent = data.hasOwnProperty("@event") ? data.@event.toString() : "";
            leadTimeNotification = data.hasOwnProperty("@notification") ? data.@notification.toString() : "";
            
            leadTimeData = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}