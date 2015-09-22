package proxy
{
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.InvestigationsVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
    import vo.ResearchVO;
    import vo.WorkerVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси активных исследований
     * 
     */
    
    public class InvestigationsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "investigationsProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function InvestigationsProxy(data:InvestigationsVO=null)
        {
            super(NAME, data);
        }
        
        public function get armyVO():InvestigationsVO
        {
            return getData() as InvestigationsVO;
        }
        
        /**
         * Получить активное исследование по его идентификатору
         * @param researchId идентификатор исследования
         * @return активное исследование
         */
        public function getResearch(researchId:String):ResearchVO
        {
            for each (var research:ResearchVO in armyVO.children)
            {
                if (research.researchId == researchId)
                    return research;
            }
            return null;
        }
        
        /**
         * Получить сотрудников из указанной базы, задействованных в указаном исследовании
         * @param researchId идентификатор исследования, если null, возвращается для всех исследований
         * @param baseId идентификатор базы, если null, возвращается для всех баз
         * @return список сотрудников
         */
        public function getEmployedScientists(researchId:String=null, baseId:String=null):Vector.<PersonVO>
        {
            var persons:Vector.<PersonVO> = new Vector.<PersonVO>();
            var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
            var personnelDecor:PersonnelHelper = new PersonnelHelper(null, personsProxy);
            
            for each (var research:ResearchVO in armyVO.children)
            {
                if (researchId && research.researchId != researchId)
                    continue;
                
                for each (var worker:WorkerVO in research.children)
                {
                    var base:BaseVO = personnelDecor.getEmployeePlace(worker.workerPersonId);
                    if (baseId && base.baseId != baseId)
                        continue;
                    
                    for each (var employee:EmployeeVO in base.basePersonnel.children)
                    {
                        if (employee.employeePersonId == worker.workerPersonId)
                        {
                            persons.push(personsProxy.getPerson(worker.workerPersonId));
                            break;
                        }
                    }
                }
            }
            
            return persons;
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:InvestigationsVO = appDataProxy.getChildByName(InvestigationsVO.NAME) as InvestigationsVO;
                
                if (!value)
                    value = new InvestigationsVO();
                
                setData(value);
                
                appDataProxy.updateChild(armyVO);
            }
            
            return data;
        }
    }
}