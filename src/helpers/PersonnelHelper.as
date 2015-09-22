package helpers
{
    import dictionary.Const;
    
    import facade.ProtoFacade;
    
    import proxy.BasesListProxy;
    import proxy.InvestigationsProxy;
    import proxy.PersonsProxy;
    import proxy.ProductionsProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
    import vo.ProductionVO;
    import vo.ResearchVO;
    import vo.WorkerVO;

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
        
        public function PersonnelHelper(basesListProxy:BasesListProxy=null, personsProxy:PersonsProxy=null)
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
            
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                var personnel:PersonnelVO = base.basePersonnel;
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
                var investigationsProxy:InvestigationsProxy = InvestigationsProxy(ProtoFacade.getInstance().retrieveProxy(InvestigationsProxy.NAME));
                var productionsProxy:ProductionsProxy = ProductionsProxy(ProtoFacade.getInstance().retrieveProxy(ProductionsProxy.NAME));
                
                for (i = 0; i < personsProxy.personsVO.children.length; i++)
                {
                    var person:PersonVO = PersonVO(personsProxy.personsVO.children[i]);
                    if (person.personId == personId)
                    {
                        personsProxy.personsVO.children.splice(i, 1);
                        break;
                    }
                }
                
                for each (var research:ResearchVO in investigationsProxy.armyVO.children)
                {
                    for (i = 0; i < research.children.length; i++)
                    {
                        var worker:WorkerVO = WorkerVO(research.children[i]);
                        if (worker.workerPersonId == personId)
                        {
                            research.children.splice(i, 1);
                            ProtoFacade.getInstance().sendNotification(Const.RESEARCH_UPDATED, research.researchId);
                            break;
                        }
                    }
                }
                
                for each (var production:ProductionVO in productionsProxy.productionsVO.children)
                {
                    for (i = 0; i < production.children.length; i++)
                    {
                        worker = WorkerVO(production.children[i]);
                        if (worker.workerPersonId == personId)
                        {
                            production.children.splice(i, 1);
                            ProtoFacade.getInstance().sendNotification(Const.PRODUCTION_UPDATED, production.productionId);
                            break;
                        }
                    }
                }
            }
            
            return baseId;
        }
        
        /**
         * Нанять сотрудника на базу
         * @param personId идентификатор персонажа сотрудника
         * @param baseId идентификатор базы
         * @param professionId идентификатор профессии, на которую нанимается сотрудник
         * @return новый сотрудник, или null, если найм невозможен
         */
        public function hireEmployee(personId:String, baseId:String, professionId:String):EmployeeVO
        {
            var base:BaseVO = basesListProxy.getBase(baseId) as BaseVO;
            var person:PersonVO = personsProxy.getPerson(personId);
            
            if (base && person)
            {
                var personnel:PersonnelVO = base.basePersonnel;
                if (!personnel)
                {
                    personnel = new PersonnelVO();
                    base.children.push(personnel);
                }
                
                person.personProfessionId = professionId;
                
                for each (var employee:EmployeeVO in personnel.children)
                {
                    if (employee.employeePersonId == person.personId)
                        return employee;        // Сотрудник уже приписан к этой базе
                }
                
                if ((new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, base) <= 0)
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
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                var personnel:PersonnelVO = base.basePersonnel;
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
		
		/**
		 * Получить сотрудников указанной профессии из указанной базы
		 * @param professionId идентификатор профессии, 0 - если запрашиваются все сотрудники указанной базы
		 * @param baseId идентификатор базы, для которой запрашиваются сотрудники, null - если запрашиваются для всех баз
		 * @return список сотрудников указанной професии из указанной базы
		 */
		public function getEmployees(professionId:String=null, baseId:String=null):Vector.<PersonVO>
		{
			var employees:Vector.<PersonVO> = new Vector.<PersonVO>();
			for each (var base:BaseVO in basesListProxy.getBasesList())
			{
				if (baseId && base.baseId != baseId)
					continue;
				
				var personnel:PersonnelVO = base.basePersonnel;
				if (!personnel)
					continue;
				
				for each (var employee:EmployeeVO in personnel.children)
				{
                    var person:PersonVO = personsProxy.getPerson(employee.employeePersonId);
					if (!professionId || person.personProfessionId == professionId)
						employees.push(person);
				}
			}
			return employees;
		}
		
		private function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
				_basesListProxy = BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
			return _basesListProxy;
		}
		
		private function get personsProxy():PersonsProxy
		{
			if (!_personsProxy)
				_personsProxy = PersonsProxy(ProtoFacade.getInstance().retrieveProxy(PersonsProxy.NAME));
			return _personsProxy;
		}
    }
}