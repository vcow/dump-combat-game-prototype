package command
{
    import command.data.MovePersonCmdData;
    
    import dictionary.Const;
    import dictionary.ProfessionsDict;
    
    import helpers.ArmyHelper;
    import helpers.ModulesHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
    import vo.PriceVO;
    import vo.ProfessionDescVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на перевод персонажа на другую базу или другую должность
     * 
     */
    
    public class MovePersonCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function MovePersonCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:MovePersonCmdData = notification.getBody() as MovePersonCmdData;
            if (data)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                
                if ((new ArmyHelper(basesListProxy)).isDraftedIntoTheArmy(data.personId))
                    return;     // Это солдат, состоящий в команде боевого юнита
                
                var movePersonComplete:Boolean = false;
                for each (var base:BaseVO in basesListProxy.basesListVO.children)
                {
                    var personnel:PersonnelVO = base.basePersonnel;
                    
                    if (!personnel)
                        continue;
                    
                    for (var i:int = 0; i < personnel.children.length; i++)
                    {
                        var employee:EmployeeVO = EmployeeVO(personnel.children[i]);
                        if (employee.employeePersonId == data.personId)
                        {
                            if (base.baseId != data.baseId)
                            {
                                // Персонаж перемещается на другую базу
                                var newBase:BaseVO = basesListProxy.getBase(data.baseId) as BaseVO;
                                if (newBase && (new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, newBase) > 0)
                                {
                                    personnel.children.splice(i, 1);
                                    
                                    var newBasePersonnel:PersonnelVO = newBase.basePersonnel;
                                    
                                    if (!newBasePersonnel)
                                    {
                                        newBasePersonnel = new PersonnelVO();
                                        newBase.children.push(newBasePersonnel);
                                    }
                                    
                                    newBasePersonnel.children.push(employee);
                                    sendNotification(Const.EMPLOYEE_IS_PLACED, employee);
                                }
                                else
                                {
                                    // Нет места, куда перемещать. Пока не ясно, как на это реагировать, сейчас
                                    // перемещение просто не происходит, в дальнейшем можно посылать сообщение, или
                                    // предлагать построить жилой модуль
                                }
                            }
                            
                            movePersonComplete = true;
                            break;
                        }
                    }
                    
                    if (movePersonComplete)
                        break;
                }
                
                if (!movePersonComplete)
                {
                    // Не найден такой персонаж ни на одной базе
                    return;
                }
                
                var person:PersonVO = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME)).getPerson(data.personId);
                if (person && person.personProfessionId != data.professionId)
                {
                    // Персонаж переводится на другую должность
                    var oldProf:ProfessionDescVO = ProfessionsDict.getInstance().getProfession(person.personProfessionId);
                    var newProf:ProfessionDescVO = ProfessionsDict.getInstance().getProfession(data.professionId);
                    if (oldProf && newProf)
                    {
                        var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                        var price:PriceVO = resourcesDecor.joinPrice(oldProf.professionHiringCost,
                            resourcesDecor.invertPrice(newProf.professionHiringCost));
                        price = resourcesDecor.separatePrice(price)[1];
                        
                        if (price.children.length > 0)
                        {
                            // Есть доплата для перевода на новую должность
                            price = resourcesDecor.invertPrice(price);
                            if (!resourcesDecor.isEnoughResources(price))
                            {
                                // Не хватает ресурсов на доплату за перевод на другую должность
                                sendNotification(Const.OPEN_SHOP, notification);
                                return;
                            }
                            
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.invertPrice(price));
                        }
                        
                        person.personProfessionId = newProf.professionId;
                        sendNotification(Const.EMPLOYEE_PROF_IS_CHANGED, person.personId);
                    }
                }
            }
        }
    }
}