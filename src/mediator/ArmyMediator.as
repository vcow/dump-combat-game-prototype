package mediator
{
    import mx.collections.ArrayCollection;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.ArmyProxy;
    
    import views.protoArmyView;
    
    [ResourceBundle("common")]
    
    public class ArmyMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "armyMediator";
        
        private var _armyProxy:ArmyProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArmyMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        /**
         * Получить список боевых юнитов
         * @return список юнитов
         */
        public function getUnits():ArrayCollection
        {
            return null;
        }
        
        protected function get armyView():protoArmyView
        {
            return viewComponent as protoArmyView;
        }
        
        protected function get productionsProxy():ArmyProxy
        {
            if (!_armyProxy)
                _armyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
            return _armyProxy;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!armyView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!armyView)
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