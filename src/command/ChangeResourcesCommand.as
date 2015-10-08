package command
{
    import mx.resources.ResourceManager;
    
    import dictionary.Const;
    import dictionary.ModulesDict;
    import dictionary.ResourcesDict;
    
    import helpers.ModulesHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
    import vo.PriceVO;
    import vo.ResourceDescVO;
    import vo.ResourceVO;
    import vo.StoreVO;
    
    [ResourceBundle("messages")]
    
    /**
     * 
     * @author y.vircowskiy
     * Запрос на изменение количества ресурсов
     * 
     */
    
    public class ChangeResourcesCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _basesListProxy:BasesListProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ChangeResourcesCommand()
        {
            super();
        }
        
        private function get basesListProxy():BasesListProxy
        {
            if (!_basesListProxy)
                _basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            return _basesListProxy;
        }
        
        /**
         * Удалить ресурсы
         * @param resourceId идентификатор ресурса
         * @param resourceCount удаляемое количество ресурса
         * @return остаток, который не удалось удалить (будет больше нуля, если ресурсов на складах не хватило)
         */
        private function removeResource(resourceId:String, resourceCount:int):int
        {
            if (resourceCount <= 0)
                return 0;
            
            var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
            
            if (bases.length == 0)
                return resourceCount;
            
            var count:int = resourceCount;
            
            for each (var base:BaseVO in bases)
            {
                var store:StoreVO = base.baseStore;
                
                if (!store)
                    continue;
                
                for each (var availableRes:ResourceVO in store.children)
                {
                    if (availableRes.resourceId == resourceId)
                    {
                        var rest:int = availableRes.resourceCount - count;
                        if (rest < 0)
                        {
                            // На этой базе ресурс исчерпан, требуется еще
                            count = -rest;
                            availableRes.resourceCount = 0;
                        }
                        else
                        {
                            count = 0;
                            availableRes.resourceCount = rest;
                        }
                        break;
                    }
                }
                
                if (count == 0)
                    break;
            }
            
            return count;
        }
        
        /**
         * Добавить ресурсы
         * @param resourceId идентификатор ресурса
         * @param resourceCount добавляемое количество ресурса
         * @param useLockedStore добавлять ресурсы в заблокированные склады
         * @return количество ресурса, размещенное на складах (будет меньше добавляемого количества, если складов не хватает)
         */
        private function addResource(resourceId:String, resourceCount:int, useLockedStore:Boolean=false):int
        {
            var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(ModuleDescVO.STORE);
            var resourceDesc:ResourceDescVO = ResourcesDict.getInstance().getResource(resourceId);
            
            if (!moduleDesc || !resourceDesc || resourceCount <= 0)
                return 0;
            
            var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
            var rest:int = resourceCount;
            
            var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy);
            for each (var base:BaseVO in bases)
            {
                if (resourceDesc.resourceSize == 0)
                {
                    // Ресурс с бесконечной вместимостью (например, деньги)
                    // пихаем в первую попавшуюся базу
                    addResourceToBase(base, resourceId, resourceCount);
                    rest = 0;
                    break;
                }
                else
                {
                    // сколко единиц ресурса поместится в найденное свободное пространство
                    var freeSpace:int = modulesHelper.getSpace(ModuleDescVO.STORE, base, useLockedStore) / resourceDesc.resourceSize;
                    
                    if (freeSpace <= 0)
                        continue;	// Для этого ресурса места нет
                    
                    var filled:int;	// Место, которое будет занято ресурсом на складах
                    if (rest > freeSpace)
                    {
                        filled = freeSpace * resourceDesc.resourceSize;
                        rest -= freeSpace;
                    }
                    else
                    {
                        filled = rest * resourceDesc.resourceSize;
                        rest = 0;
                    }
                    
                    addResourceToBase(base, resourceId, resourceCount - rest);
                }
                
                if (rest <= 0)
                    break;
            }
            
            return resourceCount - rest;
        }
        
        /**
         * Вспомогательная функция, добавляет ресурс в список ресурсов, использовать
         * только из addResource, чтобы не нарушать расчет заполнения модулей
         * @param base база, в которую добавляется ресурс
         * @param resourceId идентификатор добавляемого ресурса
         * @param count количество добавляемого ресурса
         */
        private function addResourceToBase(base:BaseVO, resourceId:String, count:int):void
        {
            // Добавить ресурс
            var resourceAdded:Boolean = false;
            var store:StoreVO = base.baseStore;
            
            if (!store)
            {
                store = new StoreVO();
                base.children.push(store);
            }
            
            for each (var resource:ResourceVO in store.children)
            {
                if (resource.resourceId == resourceId)
                {
                    resource.resourceCount += count;
                    resourceAdded = true;
                    break;
                }
            }
            
            if (!resourceAdded)
            {
                resource = new ResourceVO();
                resource.resourceId = resourceId;
                resource.resourceCount = count;
                
                store.children.push(resource);
            }
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var price:PriceVO = notification.getBody() as PriceVO;
			if (price)
			{
				var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy);
				var dc:Vector.<PriceVO> = resourcesDecor.separatePrice(price, true);
				var resourcesChanged:Boolean = false;
                
				for each (var resource:ResourceVO in dc[0].children)
				{
					var rest:int = addResource(resource.resourceId, resource.resourceCount);
                    resourcesChanged ||= rest != 0;
                    do {
    					if (rest < resource.resourceCount)
    					{
    						// Не хватает места на складах под этот ресурс
                            if (resourcesDecor.isUnlockable(resource.resourceId))
                            {
                                // На случай, если склады заблокированы за неуплату, проверяем ресурс,
                                // если он неблокируемый, производим зачисление
                                rest = addResource(resource.resourceId, resource.resourceCount, true);
                                
                                if (rest == resource.resourceCount)
                                    break;
                            }
                            
                            var message:String = ResourceManager.getInstance().getString("messages", "full.store", [ resource.resourceDesc.resourceName ]);
                            sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
    					}
                    } while (false);
                    
                    if (resource.resourceDesc.resourceTrigger)
                    {
                        var triggersProxy:TriggersProxy = TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME));
                        triggersProxy.setTriggerValue(resource.resourceDesc.resourceTrigger, 1, TriggersProxy.INC);
                        if (resource.resourceDesc.resourceIsArtifact && triggersProxy.getTriggerValue(resource.resourceDesc.resourceTrigger) == 1)
                        {
                            // Артефакт найден впервые
                            message = ResourceManager.getInstance().getString("messages", "artifact.found", [ resource.resourceDesc.resourceName ]);
                            sendNotification(Const.SEND_GAME_MESSAGE, message, Const.MESSAGE);
                        }
                    }
				}
				
				for each (resource in dc[1].children)
				{
					rest = removeResource(resource.resourceId, resource.resourceCount);
                    resourcesChanged ||= rest != resource.resourceCount;
					if (rest > 0)
					{
						// Не хватает ресурсов на складах
                        if (basesListProxy.getBasesList().length > 0)
                        {
                            message = ResourceManager.getInstance().getString("messages", "not.enough.resources", [ resource.resourceDesc.resourceName ]);
                            sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                        }
					}
				}
				
                if (resourcesChanged)
				    sendNotification(Const.RESOURCES_CHANGED);
			}
        }
    }
}