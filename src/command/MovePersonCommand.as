package command
{
    import command.data.MovePersonCmdData;
    
    import dictionary.Const;
    import dictionary.ProfessionsDict;
    
    import helpers.ModulesHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.ModuleDescVO;
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
                var personEmployee:EmployeeVO;
                
                for each (var base:BaseVO in basesListProxy.basesListVO.children)
                {
                    for (var i:int = 0; i < base.basePersonnel.children.length; i++)
                    {
                        var employee:EmployeeVO = EmployeeVO(base.basePersonnel.children[i]);
                        if (employee.employeePersonId == data.personId)
                        {
                            personEmployee = employee;
                            
                            if (base.baseId != data.baseId)
                            {
                                // Персонаж перемещается на другую базу
                                var newBase:BaseVO = basesListProxy.getBaseById(data.baseId) as BaseVO;
                                if (newBase && (new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, newBase) > 0)
                                {
                                    base.basePersonnel.children.splice(i, 1);
                                    newBase.basePersonnel.children.push(personEmployee);
                                    sendNotification(Const.EMPLOYEE_IS_PLACED, personEmployee);
                                }
                                else
                                {
                                    // Нет места, куда перемещать. Пока не ясно, как на это реагировать, сейчас
                                    // перемещение просто не происходит, в дальнейшем можно посылать сообщение, или
                                    // предлагать построить жилой модуль
                                }
                            }
                            
                            break;
                        }
                    }
                    
                    if (personEmployee)
                        break;
                }
                
                if (personEmployee && personEmployee.employeeProfessionId != data.professionId)
                {
                    // Персонаж переводится на другую должность
                    var oldProf:ProfessionDescVO = ProfessionsDict.getInstance().getProfession(personEmployee.employeeProfessionId);
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
                            
                            resourcesDecor.pay(price);
                        }
                        
                        personEmployee.employeeProfessionId = newProf.professionId;
                        sendNotification(Const.EMPLOYEE_PROF_IS_CHANGED, personEmployee);
                    }
                }
            }
        }
    }
}