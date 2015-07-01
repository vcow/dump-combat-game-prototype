package proxy
{
    import dictionary.Const;
    import dictionary.EventsDict;
    
    import events.EventsManagerEvent;
    
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
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EventsProxy()
        {
            super(NAME, EventsManager.getInstance());
        }
        
        protected function get eventsManager():EventsManager
        {
            return data as EventsManager;
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
                        if (notification.notificationChance >= 1.0 || Math.random() < notification.notificationChance)
                            sendNotification(notification.notificationId, notification.notificationData);
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
            {
                if (eventDesc.eventInterval)
                    eventsManager.activateEvent(eventDesc.eventId);
            }
        }
        
        override public function onRemove():void
        {
            super.onRemove();
            eventsManager.removeEventListener(EventsManagerEvent.EVENT, eventsManager_eventHandler);
        }
    }
}