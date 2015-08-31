package command
{
    import command.data.UpdateProductionCmdData;
    
    import dictionary.Const;
    
    import helpers.ConditionHelper;
    import helpers.ModulesHelper;
    import helpers.ProductionsHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ProductionsProxy;
    
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.ProductionVO;
    import vo.WorkerVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Запрос на изменение параметров текущего производства
     * 
     */
    
    public class UpdateProductionCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function UpdateProductionCommand()
        {
            super();
        }
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:UpdateProductionCmdData = notification.getBody() as UpdateProductionCmdData;
            
            if (data)
            {
                var productionsProxy:ProductionsProxy = ProductionsProxy(this.facade.retrieveProxy(ProductionsProxy.NAME));
                var production:ProductionVO = productionsProxy.getProduction(data.productionId);
                if (production)
                {
                    // Модифицируется существующее производство
                    var productionIsUpdated:Boolean;
                    
                    if (production.children.length > data.numEngineers)
                    {
                        // Инженеры снимаются с производства
                        var numEngineers:int = data.numEngineers < 0 ? 0 : data.numEngineers;
                        production.children.splice(0, production.children.length - numEngineers);
                        
                        productionIsUpdated = true;
                    }
                    else if (production.children.length < data.numEngineers)
                    {
                        // Инженеры ставятся на производство
                        var freeEngineers:Vector.<PersonVO> = (new ProductionsHelper(productionsProxy)).getFreeEngineers();
                        var freeWorkshopSpace:int = (new ModulesHelper()).getSpace(ModuleDescVO.WORKSHOP);
                        numEngineers = Math.min(freeEngineers.length, freeWorkshopSpace, data.numEngineers - production.children.length);
                        
                        for (var i:int = 0; i < numEngineers; i++)
                        {
                            var worker:WorkerVO = new WorkerVO();
                            worker.workerPersonId = freeEngineers[i].personId;
                            
                            production.children.push(worker);
                        }
                        
                        productionIsUpdated = true;
                    }
                    
                    if (production.productionRest != data.numProducts)
                    {
                        // Изменилось количество продукции, запланированной к выпуску
                        if (data.numProducts <= 0)
                        {
                            // Производство сворачивается
                            sendNotification(Const.COMPLETE_PRODUCTION, production.productionId);
                            return;
                        }
                        
                        production.productionRest = data.numProducts;
                        productionIsUpdated = true;
                    }
                    
                    if (productionIsUpdated)
                        sendNotification(Const.PRODUCTION_UPDATED, production.productionId);
                }
                else if (data.numProducts > 0)
                {
                    // Создается новое производство
                    production = new ProductionVO();
                    production.productionId = data.productionId;
                    production.productionPercent = 0;
                    production.productionRest = data.numProducts;
                    
                    if (!production.productionDesc)
                        throw Error("Trying to start unexisting production (" + data.productionId + ").");
                    
                    var conditionDecor:ConditionHelper = new ConditionHelper();
                    if (!conditionDecor.parseCondition(production.productionDesc.productionCondition))
                    {
                        // Производство не может быть запущено
                        return;
                    }
                    
                    var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                    if (!resourcesDecor.isEnoughResources(production.productionDesc.productionStartPrice))
                    {
                        // Не хватает ресурсов на производство даже одной единицы продукции
                        sendNotification(Const.OPEN_SHOP, notification);
                        return;
                    }
                    
                    resourcesDecor.pay(production.productionDesc.productionStartPrice);
                    productionsProxy.productionsVO.children.push(production);
                    
                    freeEngineers = (new ProductionsHelper(productionsProxy)).getFreeEngineers();
                    freeWorkshopSpace = (new ModulesHelper()).getSpace(ModuleDescVO.WORKSHOP);
                    numEngineers = Math.min(freeEngineers.length, freeWorkshopSpace, data.numEngineers);
                    
                    for (i = 0; i < numEngineers; i++)
                    {
                        worker = new WorkerVO();
                        worker.workerPersonId = freeEngineers[i].personId;
                        
                        production.children.push(worker);
                    }
                    
                    sendNotification(Const.PRODUCTION_STARTED, production.productionId);
                }
            }
        }
    }
}