package command
{
    import mx.resources.ResourceManager;
    
    import dictionary.Const;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.TriggersProxy;
    
    import vo.PriceVO;
    import vo.ResourceVO;
    
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
        
        public function ChangeResourcesCommand()
        {
            super();
        }
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var price:PriceVO = notification.getBody() as PriceVO;
			if (price)
			{
				var resourcesDecor:ResourcesHelper = new ResourcesHelper();
				var dc:Vector.<PriceVO> = resourcesDecor.separatePrice(price, true);
				var resourcesChanged:Boolean = false;
                
				for each (var resource:ResourceVO in dc[0].children)
				{
					var rest:int = resourcesDecor.addResource(resource.resourceId, resource.resourceCount);
                    resourcesChanged ||= rest != 0;
                    do {
    					if (rest < resource.resourceCount)
    					{
    						// Не хватает места на складах под этот ресурс
                            if (resourcesDecor.isUnlockable(resource.resourceId))
                            {
                                // На случай, если склады заблокированы за неуплату, проверяем ресурс,
                                // если он неблокируемый, производим зачисление
                                rest = resourcesDecor.addResource(resource.resourceId, resource.resourceCount, true);
                                
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
					rest = resourcesDecor.removeResource(resource.resourceId, resource.resourceCount);
                    resourcesChanged ||= rest != resource.resourceCount;
					if (rest > 0)
					{
						// Не хватает ресурсов на складах
                        message = ResourceManager.getInstance().getString("messages", "not.enough.resources", [ resource.resourceDesc.resourceName ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
					}
				}
				
                if (resourcesChanged)
				    sendNotification(Const.RESOURCES_CHANGED);
			}
        }
    }
}