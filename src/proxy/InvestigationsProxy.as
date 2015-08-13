package proxy
{
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.InvestigationsVO;
    import vo.PersonnelVO;
    import vo.ResearchVO;
    import vo.WorkerVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси внутриигровых триггеров
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
        
        public function get investigationsVO():InvestigationsVO
        {
            return getData() as InvestigationsVO;
        }
        
        /**
         * Получить сотрудников из указанной базы, задействованных в указаном исследовании
         * @param researchId идентификатор исследования, если null, возвращается для всех исследований
         * @param baseId идентификатор базы, если null, возвращается для всех баз
         * @return список сотрудников в виде персонала базы
         */
        public function getEmployedScientists(researchId:String=null, baseId:String=null):PersonnelVO
        {
            var personnel:PersonnelVO = new PersonnelVO;
            var personnelDecor:PersonnelHelper = new PersonnelHelper();
            
            for each (var research:ResearchVO in investigationsVO.children)
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
                            personnel.children.push(employee);
                            break;
                        }
                    }
                }
            }
            
            return personnel;
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
                
                appDataProxy.updateChild(investigationsVO);
            }
            
            return data;
        }
    }
}