package command
{
    import managers.EventsManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import vo.EventDescVO;
    
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
            
            switch (notification.getType())
            {
                case EventDescVO.SEC:
                case EventDescVO.MIN:
                case EventDescVO.ARTIFACT_FOUND:
                case EventDescVO.BATTLE_COMPLETED:
                case EventDescVO.RESEARCH_COMPLETED:
                case EventDescVO.PRODUCTION_COMPLETED:
                case EventDescVO.PAY_DAY:
                    break;
            }
        }
    }
}