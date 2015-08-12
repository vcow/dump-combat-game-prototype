package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.TriggersProxy;
    
    /**
     * 
     * @author y.vircowskiy
     * Изменилось количество ресурсов на складах
     * 
     */
    
    public class ResourcesChangedCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ResourcesChangedCommand()
        {
            super();
        }
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.RESOURCES_COUNT_TRIGGER);
        }
    }
}