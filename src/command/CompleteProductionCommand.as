package command
{
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ProductionsProxy;
    
    import vo.ProductionVO;
    import vo.ProductionsVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на завершение производства
     * 
     */
    
    public class CompleteProductionCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CompleteProductionCommand()
        {
            super();
        }
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var productionsProxy:ProductionsProxy = ProductionsProxy(this.facade.retrieveProxy(ProductionsProxy.NAME));
            
            var productions:ProductionsVO = productionsProxy.productionsVO;
            var productionId:String = notification.getBody().toString();
            for (var i:int = 0; i < productions.children.length; i++)
            {
                if (ProductionVO(productions.children[i]).productionId == productionId)
                {
                    productions.children.splice(i, 1);
                    sendNotification(Const.PRODUCTION_COMPLETED, productionId);
                    break;
                }
            }
        }
    }
}