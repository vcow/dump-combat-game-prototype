package vo
{
	import dictionary.Const;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object таймера
	 * 
	 */
	
	public class TimerVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "timer";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var timerId:String;              //< Уникальный идентификатор таймера
        public var timerStartTime:Number;       //< Время запуска таймера
        public var timerDelay:Number;           //< Прдолжительность таймера
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function TimerVO()
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
			
			res.@id = timerId || Const.NO_GUID;
            res.@startTime = isNaN(timerStartTime) ? 0 : timerStartTime;
            res.@delay = isNaN(timerDelay) ? 0 : timerDelay;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            timerId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            timerStartTime = data.hasOwnProperty("@startTime") ? Number(data.@startTime) : 0;
            timerDelay = data.hasOwnProperty("@delay") ? Number(data.@delay) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	