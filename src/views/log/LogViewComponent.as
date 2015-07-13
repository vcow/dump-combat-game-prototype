package views.log
{
    import flash.display.DisplayObjectContainer;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.core.FlexGlobals;
    import mx.managers.PopUpManager;
    
    import spark.events.PopUpEvent;
    
    import facade.ProtoFacade;
    
    import mediator.LogMediator;
    
    [Event(name="messageIsReaded", type="views.log.LogViewComponentEvent")]
    
    public class LogViewComponent extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        protected var _logMediator:LogMediator;
        
        private var _newMessagesCount:int;
        
        private var _alert:LogAlert = new LogAlert();
        private var _view:LogView;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogViewComponent()
        {
            super(null);
            
            _logMediator = LogMediator(ProtoFacade.getInstance().retrieveMediator(LogMediator.NAME));
            
            _alert.addEventListener(MouseEvent.CLICK, alert_clickHandler);
        }
        
        /**
         * Количество новых непрочитанных сообщений
         */
        public function set newMessagesCount(value:int):void
        {
            if (value == _newMessagesCount)
                return;
            
            var increase:Boolean = value > _newMessagesCount;
            _newMessagesCount = value;
            
            _alert.newMessagesCount = _newMessagesCount;
            
            if (_newMessagesCount <= 0)
            {
                if (_alert.isOpen)
                    _alert.close();
            }
            else
            {
                if (_view && _view.isOpen)
                {
                    if (increase)
                        _view.logData = _logMediator.logData;
                }
                else
                {
                    if (!_alert.isOpen)
                        _alert.open(DisplayObjectContainer(FlexGlobals.topLevelApplication), false);
                }
            }
        }
        
        /**
         * Список сообщений
         */
        public function set messages(value:ArrayCollection):void
        {
            if (_view)
                _view.logData = value;
        }
        
        /**
         * Открыть лог игровых событий
         */
        public function openLog():void
        {
            if (!_view)
            {
                _view = new LogView();
                
                _view.addEventListener(PopUpEvent.CLOSE, view_closeHandler);
                _view.addEventListener(LogListItemRendererEvent.MESSAGE_IS_READED, logItem_messageIsReadedHandler);
            }
            
            if (!_view.isOpen)
            {
                if (_alert.isOpen)
                    _alert.close();
                
                _view.logData = _logMediator.logData;
                _view.open(DisplayObjectContainer(FlexGlobals.topLevelApplication), true);
                PopUpManager.centerPopUp(_view);
            }
        }
        
        /**
         * Клик по кнопке алерта
         * @param event событие
         */
        private function alert_clickHandler(event:MouseEvent):void
        {
            openLog();
        }
        
        /**
         * Закрылось окно лога
         * @param event событие
         */
        private function view_closeHandler(event:PopUpEvent):void
        {
            _view.removeEventListener(PopUpEvent.CLOSE, view_closeHandler);
            _view.removeEventListener(LogListItemRendererEvent.MESSAGE_IS_READED, logItem_messageIsReadedHandler);
            _view = null;
            
            if (_newMessagesCount > 0 && !_alert.isOpen)
                _alert.open(DisplayObjectContainer(FlexGlobals.topLevelApplication), false);
        }
        
        /**
         * Сообщение просмотрено
         * @param event событие
         */
        private function logItem_messageIsReadedHandler(event:LogListItemRendererEvent):void
        {
            event.stopPropagation();
            dispatchEvent(new LogViewComponentEvent(LogViewComponentEvent.MESSAGE_IS_READED, event.index));
        }
    }
}