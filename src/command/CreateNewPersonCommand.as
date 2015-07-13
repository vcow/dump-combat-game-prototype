package command
{
    import command.data.HirePersonCmdData;
    
    import dictionary.CharacteristicsDict;
    import dictionary.Const;
    
    import helpers.PersonnelHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import vo.PriceVO;
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
            var data:HirePersonCmdData = notification.getBody() as HirePersonCmdData;
            if (data && data.person)
            {
                var profession:ProfessionDescVO = CharacteristicsDict.getInstance().getProfession(data.professionId);
                if (profession)
                {
                    var price:PriceVO = profession.professionHiringCost;
                    if (price)
                    {
                        var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                        if (resourcesDecor.isEnoughResources(price))
                        {
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.invertPrice(price));
                        }
                        else
                        {
                            // TODO: Отправить на докупку ресурсов
                            sendNotification(Const.OPEN_SHOP, notification);
                            return;
                        }
                    }
                }
                
                if (data.person.personId && data.person.personId != Const.NO_GUID)
                {
                    (new PersonnelHelper()).fireEmployee(data.person.personId);
                }
                else
                {
                    data.person.personId = VO.createGUID();
                    sendNotification(Const.NEW_PERSON_CREATED, data.person);
                }
                
                if (profession)
                    sendNotification(Const.PLACE_EMPLOYEE, data);
            }
        }
    }
}