package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
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
            
        }
    }
}