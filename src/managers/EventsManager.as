package managers
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import dictionary.EventsDict;
    
    import events.EventsManagerEvent;
    
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
            for (var key:String in _activatedEvents)
            {
                var timestamp:Number = _activatedEvents[key];
                if (timestamp && now >= timestamp)
                {
                    var eventDesc:EventDescVO = EventsDict.getInstance().getEvent(key);
                    _activatedEvents[key] = now + eventDesc.eventInterval;
                    
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
                    _activatedEvents[eventDesc.eventId] = (new Date()).time + eventDesc.eventInterval;
                else
                    _activatedEvents[eventDesc.eventId] = 0;
                
                dispatchEvent(new EventsManagerEvent(EventsManagerEvent.EVENT_ACTIVATED, eventDesc.eventId));
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
    }
}