package command
{
    import mx.resources.ResourceManager;
    
    import dictionary.Const;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
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
                    var isNewArtifact:Boolean = resource.resourceDesc.resourceIsArtifact && resourcesDecor.getResource(resource.resourceId) == 0;
                    
					var rest:int = resourcesDecor.addResource(resource.resourceId, resource.resourceCount);
                    resourcesChanged ||= rest != 0;
					if (rest < resource.resourceCount)
					{
						// Не хватает места на складах под этот ресурс
                        var message:String = ResourceManager.getInstance().getString("messages", "full.store", [ resource.resourceDesc.resourceName ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
					}
                    
                    if (isNewArtifact)
                    {
                        message = ResourceManager.getInstance().getString("messages", "artifact.found", [ resource.resourceDesc.resourceName ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.MESSAGE);
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