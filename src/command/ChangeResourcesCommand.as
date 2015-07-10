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
				
				for each (var resource:ResourceVO in dc[0].children)
				{
					var rest:int = resourcesDecor.addResource(resource.resourceId, resource.resourceCount);
					if (rest < resource.resourceCount)
					{
						// Не хватает места на складах под этот ресурс
                        var message:String = ResourceManager.getInstance().getString("messages", "full.store", [ resource.resourceDesc.name ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
					}
				}
				
				for each (resource in dc[1].children)
				{
					rest = resourcesDecor.removeResource(resource.resourceId, resource.resourceCount);
					if (rest > 0)
					{
						// Не хватает ресурсов на складах
                        message = ResourceManager.getInstance().getString("messages", "not.enough.resources", [ resource.resourceDesc.name ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
					}
				}
				
				sendNotification(Const.RESOURCES_CHANGED);
			}
        }
    }
}