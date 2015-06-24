package helpers
{
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.PersonnelVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор персонала
     * 
     */
    
    public class PersonnelHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _basesListProxy:BasesListProxy;
        private var _personsProxy:PersonsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonnelHelper(basesListProxy:BasesListProxy, personsProxy:PersonsProxy)
        {
            _basesListProxy = basesListProxy;
            _personsProxy = personsProxy;
        }
        
        /**
         * Уволить сотрудника
         * @param personId идентификатор персонажа
         * @param replacePerson флаг, указывающий удалить информацию по персонажу
         * @return идентификатор базы, с которой был уволен сотрудник
         */
        public function fireEmployee(personId:String, replacePerson:Boolean=true):String
        {
            var baseId:String;
            
            for each (var base:BaseVO in _basesListProxy.getBasesList())
            {
                var personnel:PersonnelVO = base.personnel;
                if (!personnel)
                    continue;
                
                for (var i:int = 0; i < personnel.children.length; i++)
                {
                    var employee:EmployeeVO = EmployeeVO(personnel.children[i]);
                    if (employee.employeePersonId == personId)
                    {
                        personnel.children.splice(i, 1);
                        baseId = base.baseId;
                        break;
                    }
                }
                
                if (baseId)
                    break;
            }
            
            if (replacePerson)
            {
                for (i = 0; i < _personsProxy.personsVO.children.length; i++)
                {
                    var person:PersonVO = PersonVO(_personsProxy.personsVO.children[i]);
                    if (person.personId == personId)
                    {
                        _personsProxy.personsVO.children.splice(i, 1);
                        break;
                    }
                }
            }
            
            return baseId;
        }
        
        /**
         * Нанять сотрудника на базу
         * @param personId идентификатор персонажа сотрудника
         * @param baseId идентификатор базы
         * @return новый сотрудник, или null, если найм невозможен
         */
        public function hireEmployee(personId:String, baseId:String):EmployeeVO
        {
            var base:BaseVO = _basesListProxy.getBaseById(baseId) as BaseVO;
            var person:PersonVO = _personsProxy.getPersonById(personId);
            
            if (base && person)
            {
                var personnel:PersonnelVO = base.personnel;
                if (!personnel)
                {
                    personnel = new PersonnelVO();
                    base.children.push(personnel);
                }
                
                for each (var employee:EmployeeVO in personnel.children)
                {
                    if (employee.employeePersonId == person.personId)
                        return employee;        // Сотрудник уже приписан к этой базе
                }
                
                if ((new ModulesHelper(_basesListProxy)).getSpace(ModuleDescVO.HOUSING, base) <= 0)
                    return null;                // Нет места на этой базе
                
                employee = new EmployeeVO();
                employee.employeePersonId = person.personId;
                
                personnel.children.push(employee);
                return employee;
            }
            
            return null;
        }
        
        /**
         * Найти базу приписки для сотрудника
         * @param personId идентификатор персонажа сотрудника
         * @return база приписки сотрудника
         */
        public function getEmployeePlace(personId:String):BaseVO
        {
            for each (var base:BaseVO in _basesListProxy.getBasesList())
            {
                var personnel:PersonnelVO = base.personnel;
                if (!personnel)
                    continue;
                
                for each (var employee:EmployeeVO in personnel.children)
                {
                    if (employee.employeePersonId == personId)
                        return base;
                }
            }
            return null;
        }
    }
}