package command
{
    import command.data.HirePersonCmdData;
    
    import dictionary.Const;
    
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import vo.VO;
    
    /**
     * 
     * @author y.vircowskiy
     * Отправлен запрос на создание нового персонажа
     * 
     */
    
    public class CreateNewPersonCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CreateNewPersonCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:HirePersonCmdData = notification.getBody() as HirePersonCmdData;
            if (data)
            {
                if (data.person)
                {
                    if (data.person.personId && data.person.personId != Const.NO_GUID)
                        (new PersonnelHelper()).fireEmployee(data.person.personId);
                    
                    data.person.personId = VO.createGUID();
                    sendNotification(Const.NEW_PERSON_CREATED, data.person);
                }
            }
            
            sendNotification(Const.PLACE_EMPLOYEE, data);
        }
    }
}