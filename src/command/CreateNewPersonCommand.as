package command
{
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import vo.PersonVO;
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
            var person:PersonVO = notification.getBody() as PersonVO;
            if (person)
            {
                person.personId = VO.createGUID();
                sendNotification(Const.NEW_PERSON_CREATED, person);
            }
        }
    }
}