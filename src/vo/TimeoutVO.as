package vo
{
    import helpers.TimeHelper;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object квестового таймаута
	 * 
	 */
	
	public class TimeoutVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "timeout";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var timeoutDelay:Number;             //< Время таймаута в милисекундах
        public var timeoutAsync:Boolean;            //< Флаг, указывающий на асинхронность таймера
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function TimeoutVO()
		{
			super(NAME);
		}
        
        /**
         * Результат срабатывания таймаута
         */
        public function get timeoutResult():ResultVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ResultVO.NAME)
                    return item as ResultVO;
            }
            return null;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@delay = (new TimeHelper()).timeToStr(timeoutDelay);
            
            if (timeoutAsync)
                res.@async = timeoutAsync;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            timeoutDelay = data.hasOwnProperty("@delay") ? (new TimeHelper()).strToTime(data.@delay.toString()) : NaN;
            timeoutAsync = data.hasOwnProperty("@async") ? data.@async.toString().toLowerCase() == "true" : false;
			
			// /TODO
			
			return true;
		}
	}
}