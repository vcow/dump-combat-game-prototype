package command
{
    import dictionary.Const;
    import dictionary.ResourcesDict;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import vo.PriceVO;
    import vo.ResourceDescVO;
    import vo.ResourceVO;
    
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
            resource.resourceId = data ? uint(data.resourceId) : 0;
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
                }
            }
        }
    }
}