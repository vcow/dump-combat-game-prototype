package command
{
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.RaidsProxy;
    
    import vo.RaidVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Проверки, выполняемые после загрузки
     * 
     */
    
    public class StartupCheckCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function StartupCheckCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            // Проверить наличие рейдов, ожидающих решения игрока
            for each (var raid:RaidVO in RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME)).raidsVO.children)
            {
                if (raid.raidDelayed)
                    sendNotification(Const.CONFIRM_ATTACK_BASE, raid.raidId);
            }
        }
    }
}