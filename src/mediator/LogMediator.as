package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.LogProxy;
    import proxy.data.LogRecordData;
    
    import views.log.LogViewComponent;
    import views.log.LogViewComponentEvent;
    
    /**
     * 
     * @author y.vircowskiy
     * Медиатор для окна сообщений
     * 
     */
    
    public class LogMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "logMediator";
        
        private var _logProxy:LogProxy;
        
        private var _logData:ArrayCollection = new ArrayCollection();
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            applyViewComponent();
        }
        
        public function get logData():ArrayCollection
        {
            for (var i:int = _logData.length; i < logProxy.log.length; i++)
            {
                var record:LogRecordData = logProxy.log[i];
                _logData.addItem({
                    message: String(record),
                    index: record.index,
                    readed: !record.isNew
                });
                
                if (_logData.length > 100)
                    _logData.removeItemAt(0);
            }
            return _logData;
        }
        
        /**
         * Количество непрочитанных записей
         */
        public function get newMessagesCount():int
        {
            var ctr:int = 0;
            for each (var record:LogRecordData in logProxy.log)
            {
                if (record.isNew)
                    ctr++;
            }
            return ctr;
        }
        
        protected function get logViewComponent():LogViewComponent
        {
            return viewComponent as LogViewComponent;
        }
        
        protected function get logProxy():LogProxy
        {
            if (!_logProxy)
                _logProxy = LogProxy(this.facade.retrieveProxy(LogProxy.NAME));
            return _logProxy;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!logViewComponent)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            logViewComponent.removeEventListener(LogViewComponentEvent.MESSAGE_IS_READED, logViewComponent_messageIsReadedHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!logViewComponent)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            logViewComponent.newMessagesCount = newMessagesCount;
            logViewComponent.messages = logData;
            
            logViewComponent.addEventListener(LogViewComponentEvent.MESSAGE_IS_READED, logViewComponent_messageIsReadedHandler);
            
            // /TODO
        }
        
        /**
         * Сообщение прочитано
         * @param event событие
         */
        private function logViewComponent_messageIsReadedHandler(event:LogViewComponentEvent):void
        {
            try {
                var message:LogRecordData = logProxy.log[event.messageIndex];
                if (message.isNew)
                {
                    message.isNew = false;
                    if (logViewComponent)
                        logViewComponent.newMessagesCount = newMessagesCount;
                }
            }
            catch (e:Error) {
            }
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
            return [ Const.GAME_MESSAGE_SENT, Const.OPEN_GAME_LOG ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.GAME_MESSAGE_SENT:
                    if (logViewComponent)
                        logViewComponent.newMessagesCount = newMessagesCount;
                    break;
                case Const.OPEN_GAME_LOG:
                    if (logViewComponent)
                        logViewComponent.openLog();
                    break;
            }
        }
    }
}