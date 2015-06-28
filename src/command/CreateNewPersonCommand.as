package command
{
    import dictionary.CharacteristicsDict;
    import dictionary.Const;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import vo.PersonVO;
    import vo.ProfessionDescVO;
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
			var profession:ProfessionDescVO = notification.getType() ? CharacteristicsDict.getInstance().getProfession(uint(parseInt(notification.getType()))) : null;
            if (person)
            {
                if (!profession || !profession.professionHiringCost || (new ResourcesHelper()).pay(profession.professionHiringCost))
                {
                    person.personId = VO.createGUID();
                    sendNotification(Const.NEW_PERSON_CREATED, person);
                }
            }
        }
    }
}