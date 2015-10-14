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
    import vo.TriggerVO;
    
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
            // Прогнать событие по дереву
            sendNotification(Const.GAME_EVENT, null, event.event.eventId);
            
            for each (var secondary:IVO in event.event.children)
            {
                // У этого события имеются дополнительные действия
                switch (secondary.name)
                {
                    case NotificationVO.NAME:       // Отправить нотификацию
                        var notification:NotificationVO = NotificationVO(secondary);
                        
                        // Проверить наличие и выполнение условия отправки
                        if ((new ConditionHelper(triggersProxy)).parseCondition(notification.notificationCondition))
                            sendNotification(notification.notificationId, notification.notificationData);
                        break;
                    case TriggerVO.NAME:            // Задать значение триггера
                        var trigger:TriggerVO = TriggerVO(secondary);
                        triggersProxy.setTriggerValue(trigger.triggerId, trigger.triggerValue, trigger.triggerValueType);
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