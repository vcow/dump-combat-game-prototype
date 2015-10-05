package command
{
    import managers.EventsManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.InvestigationsProxy;
    import proxy.PersonsProxy;
    import proxy.ProductionsProxy;
    
    import vo.BasesVO;
    import vo.InvestigationsVO;
    import vo.PersonsVO;
    import vo.ProductionsVO;
    
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
            
			// Прокинуть евент по всем базам, отправить нотфикации, которые вернут value object-ы
            var bases:BasesVO = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).basesListVO;
            bases.event(notification.getType(), notification.getBody());
            
            // Прокинуть евент по всем сотрудникам
            var persons:PersonsVO = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME)).personsVO;
            persons.event(notification.getType(), notification.getBody());
            
            // Прокинуть евент по всем исследованиям
            var investigations:InvestigationsVO = InvestigationsProxy(this.facade.retrieveProxy(InvestigationsProxy.NAME)).armyVO;
            investigations.event(notification.getType(), notification.getBody());
            
            // Прокинуть евент по производствам
            var productions:ProductionsVO = ProductionsProxy(this.facade.retrieveProxy(ProductionsProxy.NAME)).productionsVO;
            productions.event(notification.getType(), notification.getBody());
        }
    }
}