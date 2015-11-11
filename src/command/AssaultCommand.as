package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.RaidsProxy;
    
    import vo.RaidVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на захват базы
     * 
     */
    
    public class AssaultCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function AssaultCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var raidsProxy:RaidsProxy = RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME));
            var raid:RaidVO = raidsProxy.getRaid(notification.getBody().toString());
            if (raid)
            {
                
            }
        }
    }
}