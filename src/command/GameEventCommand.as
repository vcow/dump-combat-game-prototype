package command
{
    import managers.EventsManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Произошло внутриигровое событие
     * 
     */
    
    public class GameEventCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function GameEventCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            if (!EventsManager.getInstance().isEventActive(notification.getType()))
                throw Error("Inactive game event (" + notification.getType() + ").");
            
            var bases:Vector.<BaseVO> = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBasesList();
            for each (var base:BaseVO in bases)
            {
                var out:Object = {};
                base.event(notification.getType(), out);
                
                for (var key:String in out)
            }
        }
    }
}