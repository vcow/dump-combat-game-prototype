package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    /**
     * 
     * @author y.vircowskiy
     * Отправлен запрос на найм сотрудника
     * 
     */
    
    public class HireEmployeeCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function HireEmployeeCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
        }
    }
}