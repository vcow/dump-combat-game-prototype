package command
{
    import command.data.HirePersonCmdData;
    
    import dictionary.Const;
    
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Отправлен запрос на найм сотрудника
     * 
     */
    
    public class PlaceEmployeeCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PlaceEmployeeCommand()
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
                var baseListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                
                var base:BaseVO = baseListProxy.getBaseById(data.baseId) as BaseVO;
                if (data.person && data.person.personId && data.person.personId != Const.NO_GUID && base)
                {
                    var personnel:PersonnelVO = base.basePersonnel;
                    if (!personnel)
                    {
                        personnel = new PersonnelVO();
                        base.children.push(personnel);
                    }
                    
                    var personnelHelper:PersonnelHelper = new PersonnelHelper(baseListProxy);
                    
                    personnelHelper.fireEmployee(data.person.personId, false);
                    var employee:EmployeeVO = personnelHelper.hireEmployee(data.person.personId, base.baseId, data.professionId);
                    
                    if (employee)
                        sendNotification(Const.EMPLOYEE_IS_PLACED, employee);
                }
            }
        }
    }
}