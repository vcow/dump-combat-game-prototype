package managers
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import dictionary.EventsDict;
    
    import events.EventsManagerEvent;
    
    import facade.ProtoFacade;
    
    import proxy.AppDataProxy;
    
    import vo.EventDescVO;
    
    [Event(name="tick", type="events.EventsManagerEvent")]
    [Event(name="event", type="events.EventsManagerEvent")]
    [Event(name="eventActivated", type="events.EventsManagerEvent")]
    [Event(name="eventDeactivated", type="events.EventsManagerEvent")]
    
    /**
     * 
     * @author y.vircowskiy
     * Менеджер внутриигровых событий
     * 
     */
    
    public class EventsManager extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private static var _instance:EventsManager;
        private static var _activatedEvents:Dictionary = new Dictionary();
        
        private var _appDataProxy:AppDataProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EventsManager()
        {
            if (_instance != null)
                throw Error("EventsManager is singleton, use getInstance() to get it.");
            _instance = super(null);
        }
        
        public static function getInstance():EventsManager
        {
            if (!_instance)
                _instance = new EventsManager();
            return _instance;
        }
        
        /**
         * Внутриигровой тик
         */
        public function tick():void
        {
            if (hasEventListener(EventsManagerEvent.TICK))
                dispatchEvent(new EventsManagerEvent(EventsManagerEvent.TICK));
            
            var now:Number = (new Date()).time;
            appDataProxy.stuff.timestamp = now;
            
            for (var key:String in _activatedEvents)
            {
                var eventTimestamp:Number = _activatedEvents[key];
                if (eventTimestamp && now >= eventTimestamp)
                {
                    var eventDesc:EventDescVO = EventsDict.getInstance().getEvent(key);
                    _activatedEvents[key] = now + eventDesc.eventInterval;
                    eventLastTimes[key] = now;
                    
                    dispatchEvent(new EventsManagerEvent(EventsManagerEvent.EVENT, key));
                }
            }
        }
        
        /**
         * Активировать событие. Во время игровой сессии должны использоваться только активированные события,
         * события, имеющие интервал, после активации автоматически начинают генерироваться через указанный
         * промежуток времени
         * @param eventId идентификатор активируемого события
         */
        public function activateEvent(eventId:String):void
        {
            var interval:Number = Number(_activatedEvents[eventId]);
            if (isNaN(interval))
            {
                var eventDesc:EventDescVO = EventsDict.getInstance().getEvent(eventId);
                if (!eventDesc)
                    throw Error("An attempt to activate the undefined event (" + eventId + ").");
                
                if (eventDesc.eventInterval)
                {
                    // Событие имеет диапазон и должно автоматически генерироваться по внутриигровому тику
                    // Проверить наличие срабатываний в прошлом, расчитать остаток времени с момента
                    // возобновления игры до следующего срабатывания интервального события
                    var now:Number = (new Date()).time;
                    var eventLastTime:Number = eventLastTimes[eventDesc.eventId];
                    if (isNaN(eventLastTime))
                    {
                        eventLastTimes[eventDesc.eventId] = eventLastTime = now;
                        _activatedEvents[eventDesc.eventId] = now + eventDesc.eventInterval;
                    }
                    else
                    {
                        var exitTime:Number = appDataProxy.stuff.exitTime;
                        if (isNaN(exitTime) || exitTime  < eventLastTime)
                            _activatedEvents[eventDesc.eventId] = now + eventDesc.eventInterval;
                        else
                            _activatedEvents[eventDesc.eventId] = now + eventDesc.eventInterval - (exitTime - eventLastTime);
                    }
                }
                else
                {
                    // Событие не имеет диапазона, генерируется игровой логикой
                    _activatedEvents[eventDesc.eventId] = 0;
                }
                
                dispatchEvent(new EventsManagerEvent(EventsManagerEvent.EVENT_ACTIVATED, eventDesc.eventId));
            }
			
			if (!eventLastTimes[eventId])
			{
				// Если событие до сих пор ни разу не использовалось, считаем
				// моментом первого использования момент активации
				eventLastTimes[eventId] = (new Date()).time;
			}
        }
        
        /**
         * Деактивировать событие. Деактивированное событие не может использоватсья и перестает генерироваться
         * автоматически, если оно имело интервал
         * @param eventId идентификатор деактивируемого события
         */
        public function deactivateEvent(eventId:String):void
        {
            var interval:Number = Number(_activatedEvents[eventId]);
            if (!isNaN(interval))
            {
                delete _activatedEvents[eventId];
                dispatchEvent(new EventsManagerEvent(EventsManagerEvent.EVENT_DEACTIVATED, eventId));
            }
        }
        
        /**
         * Проверить событие на активность
         * @param eventId идентификатор проверяемого события
         * @return true, если событие активно
         */
        public function isEventActive(eventId:String):Boolean
        {
            return _activatedEvents[eventId] != null;
        }
        
        protected function get appDataProxy():AppDataProxy
        {
            if (!_appDataProxy)
                _appDataProxy = ProtoFacade.getInstance().retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            return _appDataProxy;
        }
        
        /**
         * Список временных меток последних срабатываний для интервальных событий
         */
        protected function get eventLastTimes():Object
        {
            var times:Object = appDataProxy.stuff.eventLastTimes;
            if (!times)
                appDataProxy.stuff.eventLastTimes = times = {};
            return times;
        }
    }
}