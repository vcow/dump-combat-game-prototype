package mediator
{
    import mx.collections.ArrayCollection;
    
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.LogProxy;
    import proxy.data.LogRecordData;
    
    import views.log.LogViewComponent;
    
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
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        public function get logData():ArrayCollection
        {
            var data:Array = [];
            for each (var record:LogRecordData in logProxy.log)
            {
                data.push({
                    message: String(record),
                    index: record.index,
                    readed: !record.isNew
                });
            }
            return new ArrayCollection(data);
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
            
            // /TODO
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
    }
}