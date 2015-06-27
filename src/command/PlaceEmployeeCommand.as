package command
{
    import dictionary.Const;
    
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
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
            var baseListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            
            var person:PersonVO = notification.getBody() as PersonVO;
            var base:BaseVO = baseListProxy.getBaseById(notification.getType()) as BaseVO;
            if (person && base)
            {
                var personnel:PersonnelVO = base.personnel;
                if (!personnel)
                {
                    personnel = new PersonnelVO();
                    base.children.push(personnel);
                }
                
                var personnelHelper:PersonnelHelper = new PersonnelHelper(baseListProxy);
                
                personnelHelper.fireEmployee(person.personId, false);
                var employee:EmployeeVO = personnelHelper.hireEmployee(person.personId, base.baseId);
                
                if (employee)
                    sendNotification(Const.EMPLOYEE_IS_PLACED, employee);
            }
        }
    }
}