package mediator
{
    import dictionary.Const;
    
    import events.EventsManagerEvent;
    
    import managers.EventsManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.IVariableDataProxy;
    
    /**
     * 
     * @author y.vircowskiy
     * Медиатор системы внутриигровых событий
     * 
     */
    
    public class EventsMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "eventsMediator";
        
        private var _saveLater:Vector.<IVariableDataProxy> = new Vector.<IVariableDataProxy>();
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EventsMediator()
        {
            super(NAME, EventsManager.getInstance());
        }
        
        protected function get eventsManager():EventsManager
        {
            return viewComponent as EventsManager;
        }
        
        /**
         * Освободить текущий визуальный компонент (в качестве которого у этого медиатора используется менеджер внутриигровых событий)
         */
        private function releaseViewComponent():void
        {
            if (!eventsManager)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            eventsManager.removeEventListener(EventsManagerEvent.EVENT, eventsManager_eventHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент (в качестве которого у этого медиатора используется менеджер внутриигровых событий)
         */
        private function applyViewComponent():void
        {
            if (!eventsManager)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            eventsManager.addEventListener(EventsManagerEvent.EVENT, eventsManager_eventHandler);
            
            // /TODO
        }
        
        /**
         * Менеджер сгенерировал интервальное внутриигровое событие
         * @param event событие
         */
        private function eventsManager_eventHandler(event:EventsManagerEvent):void
        {
            sendNotification(Const.GAME_EVENT, null, event.eventId);
        }
        
        /**
         * Внутриигровой тик
         * @param event событие
         */
        private function eventsManager_tickHandler(event:EventsManagerEvent):void
        {
            eventsManager.removeEventListener(EventsManagerEvent.TICK, eventsManager_tickHandler);
            
            for each (var variableDataProxy:IVariableDataProxy in _saveLater)
                variableDataProxy.saveData(true);
            
            _saveLater.splice(0, _saveLater.length);
        }
        
        //----------------------------------
        //  Mediator
        //----------------------------------
        
        override public function setViewComponent(viewComponent:Object):void
        {
            releaseViewComponent();
            super.setViewComponent(viewComponent);
            applyViewComponent();
        }
        
        override public function listNotificationInterests():Array
        {
            return [ Const.SAVE_DATA ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.SAVE_DATA:
                    var variableDataProxy:IVariableDataProxy = notification.getBody() as IVariableDataProxy;
                    if (variableDataProxy)
                    {
                        // Какая-то прокся попросила сохранить свои данные с задержкой
                        if (_saveLater.length == 0)
                            eventsManager.addEventListener(EventsManagerEvent.TICK, eventsManager_tickHandler);
                        
                        _saveLater.push(variableDataProxy);
                    }
                    break;
            }
        }
    }
}