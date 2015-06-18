package command
{
    import dictionary.CharacteristicsDict;
    import dictionary.Const;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.AppDataProxy;
    import proxy.BasesListProxy;
    
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
            if (person)
            {
                var profession:ProfessionDescVO = CharacteristicsDict.getInstance().getProfession(person.personProfessionId);
                if (profession)
                {
                    var resourcesDecor:ResourcesHelper = new ResourcesHelper(
                        BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)),
                        AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)));
                    
                    if (!profession.professionHiringCost || resourcesDecor.pay(profession.professionHiringCost))
                    {
                        person.personId = VO.createGUID();
                        sendNotification(Const.NEW_PERSON_CREATED, person);
                    }
                }
            }
        }
    }
}