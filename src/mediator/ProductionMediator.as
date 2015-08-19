package mediator
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import views.protoProductionView;
    
    public class ProductionMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "productionMediator";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        protected function get productionView():protoProductionView
        {
            return viewComponent as protoProductionView;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!productionView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!productionView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            
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
        
        override public function listNotificationInterests():Array
        {
            return [  ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                
            }
        }
    }
}