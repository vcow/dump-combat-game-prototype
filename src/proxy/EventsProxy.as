package proxy
{
    import dictionary.Const;
    import dictionary.EventsDict;
    
    import events.EventsManagerEvent;
    
    import facade.ProtoFacade;
    
    import helpers.ConditionHelper;
    
    import managers.EventsManager;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.EventDescVO;
    import vo.IVO;
    import vo.NotificationVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси внутриигровых событий
     * 
     */
    
    public class EventsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "eventsProxy";
        
        private var _triggersProxy:TriggersProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EventsProxy()
        {
            super(NAME, EventsManager.getInstance());
        }
        
        protected function get eventsManager():EventsManager
        {
            return getData() as EventsManager;
        }
        
        protected function get triggersProxy():TriggersProxy
        {
            if (!_triggersProxy)
                _triggersProxy = TriggersProxy(ProtoFacade.getInstance().retrieveProxy(TriggersProxy.NAME));
            return _triggersProxy;
        }
        
        /**
         * Менеджер сгенерировал интервальное внутриигровое событие
         * @param event событие
         */
        private function eventsManager_eventHandler(event:EventsManagerEvent):void
        {
            sendNotification(Const.GAME_EVENT, null, event.event.eventId);
            
            for each (var secondary:IVO in event.event.children)
            {
                switch (secondary.name)
                {
                    case NotificationVO.NAME:
                        var notification:NotificationVO = NotificationVO(secondary);
                        
                        var conditionIsSatisfied:Boolean = notification.notificationData.hasOwnProperty("condition") ?
                            (new ConditionHelper(triggersProxy)).parseCondition(notification.notificationData.condition) : true;
                        
                        if (conditionIsSatisfied &&
                            (notification.notificationChance >= 1.0 || Math.random() < notification.notificationChance))
                        {
                            sendNotification(notification.notificationId, notification.notificationData);
                        }
                        break;
                }
            }
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function onRegister():void
        {
            super.onRegister();
            
            eventsManager.addEventListener(EventsManagerEvent.EVENT, eventsManager_eventHandler);
            
            // Стартовать систему событий
            for each (var eventDesc:EventDescVO in EventsDict.getInstance().events)
                eventsManager.activateEvent(eventDesc.eventId);
        }
        
        override public function onRemove():void
        {
            super.onRemove();
            eventsManager.removeEventListener(EventsManagerEvent.EVENT, eventsManager_eventHandler);
        }
    }
}