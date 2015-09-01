package command
{
    import dictionary.Const;
    
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.TriggersProxy;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на удаление персонажа
     * 
     */
    
    public class ReplacePersonCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ReplacePersonCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var personId:String = notification.getBody().toString();
            if ((new PersonnelHelper()).fireEmployee(personId))
            {
                TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.EMPLOYEES_COUNT_TRIGGER);
                sendNotification(Const.PERSON_IS_REPLACED, personId);
            }
        }
    }
}