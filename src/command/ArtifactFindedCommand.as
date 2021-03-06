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
     * Найден артефакт
     * 
     */
    
    public class ArtifactFindedCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArtifactFindedCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:Object = notification.getBody();
            
            var resource:ResourceVO = new ResourceVO();
            resource.resourceId = data ? data.resourceId.toString() : "";
            resource.resourceCount = 1;
            
            if (resource.resourceDesc)
            {
                var price:PriceVO = new PriceVO();
                price.children.push(resource)
                
                var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                if (resourcesDecor.isEnouchSpace(price))
                {
                    sendNotification(Const.CHANGE_RESOURCES, price);
                }
                else
                {
                    // Сообщить о нехватке места на складах под найденный артефакт
                    var message:String = ResourceManager.getInstance().getString("messages", "artifact.lost", [ resource.resourceDesc.resourceName ]);
                    sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                }
            }
        }
    }
}