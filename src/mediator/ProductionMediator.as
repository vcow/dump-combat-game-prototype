package mediator
{
    import command.data.UpdateProductionCmdData;
    
    import dictionary.Const;
    
    import events.ProductionEvent;
    
    import helpers.ProductionsHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.ProductionsProxy;
    
    import views.ui.ProductionView;
    
    import vo.ProductionVO;
    
    public class ProductionMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "productionMediator";
        
        private var _productionsProxy:ProductionsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Получить количество инженеров, задействованных в указанном производстве
         * @param productionId идентификатор производства
         * @return количество задействованных инженеров
         */
        public function getEmployedEngineers(productionId:String):int
        {
            return productionsProxy.getEmployedEngineers(productionId).children.length;
        }
        
        /**
         * Получить количество продукции, запланированной к производству
         * @param productionId идентификатор продукции
         * @return количество запланированной продукции
         */
        public function getProductionsCount(productionId:String):int
        {
            var production:ProductionVO = productionsProxy.getProduction(productionId);
            return production ? production.productionRest : 0;
        }
        
        /**
         * Получить количество незадействованных инженеров
         * @return количество незадействованных инженеров
         */
        public function getFreeEngineers():int
        {
            return (new ProductionsHelper(productionsProxy)).getFreeEngineers().length;
        }
        
        protected function get productionView():ProductionView
        {
            return viewComponent as ProductionView;
        }
        
        protected function get productionsProxy():ProductionsProxy
        {
            if (!_productionsProxy)
                _productionsProxy = this.facade.retrieveProxy(ProductionsProxy.NAME) as ProductionsProxy;
            return _productionsProxy;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!productionView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            productionView.removeEventListener(ProductionEvent.CHANGE_PRODUCTION_ENGINEERS_COUNT, changeProductionHandler);
            productionView.removeEventListener(ProductionEvent.CHANGE_PRODUCTS_COUNT, changeProductionHandler);
            
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
            
            productionView.addEventListener(ProductionEvent.CHANGE_PRODUCTION_ENGINEERS_COUNT, changeProductionHandler);
            productionView.addEventListener(ProductionEvent.CHANGE_PRODUCTS_COUNT, changeProductionHandler);
            
            // /TODO
        }
        
        private function changeProductionHandler(event:ProductionEvent):void
        {
            sendNotification(Const.UPDATE_PRODUCTION, new UpdateProductionCmdData(event.productionId, event.numEngineers, event.numProducts));
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
            return [ Const.PRODUCTION_COMPLETED, Const.PRODUCTION_UPDATED, Const.PRODUCT_UNIT_COMPLETED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.PRODUCTION_COMPLETED:
                    if (productionView)
                    {
                        if (notification.getBody().toString() == productionView.productionId)
                            productionView.goBack();
                        else
                            productionView.freeEngineers = getFreeEngineers();
                    }
                    break;
                case Const.RESEARCH_UPDATED:
                    if (productionView)
                    {
                        if (notification.getBody().toString() == productionView.productionId)
                        {
                            productionView.freeEngineers = getFreeEngineers();
                            productionView.employeedEngineers = getEmployedEngineers(productionView.productionId);
                            productionView.productionsCount = getProductionsCount(productionView.productionId);
                        }
                    }
                    break;
                case Const.PRODUCT_UNIT_COMPLETED:
                    if (productionView)
                    {
                        if (notification.getBody().toString() == productionView.productionId)
                            productionView.productionsCount = getProductionsCount(productionView.productionId);
                    }
                    break;
            }
        }
    }
}