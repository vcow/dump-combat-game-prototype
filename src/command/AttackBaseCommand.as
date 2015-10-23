package command
{
    import command.data.AttackBaseCmdData;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    /**
     * 
     * @author y.vircowskiy
     * Атака базы
     * 
     */
    
    public class AttackBaseCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function AttackBaseCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:AttackBaseCmdData = notification.getBody() as AttackBaseCmdData;
            if (data)
            {
                
            }
        }
    }
}