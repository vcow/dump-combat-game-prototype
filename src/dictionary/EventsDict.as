package dictionary
{
	import vo.EventDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека внутриигровых событий
	 * 
	 */
	
	public final class EventsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/events.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:EventsDict;
		private static var _events:Vector.<EventDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function EventsDict()
        {
            if (_instance != null)
                throw Error("EventsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():EventsDict
		{
			if (!_instance)
				_instance = new EventsDict();
			return _instance;
		}
        
        public function get events():Vector.<EventDescVO>
        {
			if (!_events)
			{
                _events = new Vector.<EventDescVO>();
				
				var src:XML = XML(new source());
				var items:XMLList = src.child(EventDescVO.NAME);
				for each (var item:XML in items)
				{
					var event:EventDescVO = new EventDescVO();
                    event.deserialize(item);
                    _events.push(event);
				}
			}
            return _events;
        }
		
		/**
		 * Получить информацию по событию
		 * @param resourceId идентификатор события
		 * @return информация по событию
		 */
		public function getEvent(eventId:String):EventDescVO
		{
			for each (var event:EventDescVO in events)
			{
				if (event.eventId == eventId)
					return event;
			}
			return null;
		}
	}
}