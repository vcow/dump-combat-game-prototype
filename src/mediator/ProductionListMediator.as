package mediator
{
    import mx.collections.ArrayCollection;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    
    import command.data.UpdateProductionCmdData;
    
    import dictionary.Const;
    import dictionary.ProductionsDict;
    
    import events.ProductionEvent;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.ProductionsProxy;
    
    import views.protoProductionView;
    
    import vo.PriceVO;
    import vo.ProductionDescVO;
    import vo.ProductionVO;
    import vo.ResourceVO;
    
    [ResourceBundle("common")]
    
    public class ProductionListMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "productionListMediator";
        
        private var _productionsProxy:ProductionsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionListMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        /**
         * Получить список всех доступных производств
         * @return список доступных производств
         */
        public function getAvailableProductions():ArrayCollection
        {
            var prod:Array = [];
            var productions:Vector.<ProductionDescVO> = ProductionsDict.getInstance().getAvailableProductions();
            for each (var production:ProductionDescVO in productions)
            {
                if (productionsProxy.getProduction(production.productionId))
                    continue;
                
                prod.push({
                    id: production.productionId,
                    label: production.productionName,
                    description: production.productionDescription,
                    requirements: getRequirements(production.productionStartPrice)
                });
            }
            return new ArrayCollection(prod);
        }
        
        public function getActiveProductions():ArrayCollection
        {
            var prod:Array = [];
            for each (var production:ProductionVO in productionsProxy.productionsVO.children)
            {
                prod.push({
                    id: production.productionDesc.productionId,
                    label: production.productionDesc.productionName,
                    description: production.productionDesc.productionDescription,
                    requirements: getRequirements(production.productionDesc.productionStartPrice)
                });
            }
            return new ArrayCollection(prod);
        }
        
        protected function get productionView():protoProductionView
        {
            return viewComponent as protoProductionView;
        }
        
        protected function get productionsProxy():ProductionsProxy
        {
            if (!_productionsProxy)
                _productionsProxy = ProductionsProxy(this.facade.retrieveProxy(ProductionsProxy.NAME));
            return _productionsProxy;
        }
        
        private function getRequirements(price:PriceVO):String
        {
            var str:String = "";
            var resourceManager:IResourceManager = ResourceManager.getInstance();
            for (var i:int = 0; i < price.children.length; i++)
            {
                var resource:ResourceVO = ResourceVO(price.children[i]);
                var res:String = resourceManager.getString("common", "production.requirements.resource",
                    [ resource.resourceDesc.resourceName, resource.resourceCount ]);
                str += res + (i == price.children.length - 1 ? "." : "; ");
            }
            return resourceManager.getString("common", "production.requirements", [ str ]);
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!productionView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            productionView.removeEventListener(ProductionEvent.START_PRODUCTION, startProductionHandler);
            
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
            
            productionView.addEventListener(ProductionEvent.START_PRODUCTION, startProductionHandler);
            
            // /TODO
        }
        
        private function startProductionHandler(event:ProductionEvent):void
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
            return [ Const.PRODUCTION_UPDATED, Const.PRODUCTION_STARTED, Const.PRODUCTION_COMPLETED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.PRODUCTION_UPDATED:
                case Const.PRODUCTION_STARTED:
                case Const.PRODUCTION_COMPLETED:
                if (productionView)
                    productionView.updateList();
                break;
            }
        }
    }
}