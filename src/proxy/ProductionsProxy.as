package proxy
{
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
    import vo.ProductionVO;
    import vo.ProductionsVO;
    import vo.WorkerVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси активных производств
     * 
     */
    
    public class ProductionsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "productionsProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionsProxy(data:ProductionsVO=null)
        {
            super(NAME, data);
        }
        
        public function get productionsVO():ProductionsVO
        {
            return getData() as ProductionsVO;
        }
        
        /**
         * Получить активное производство по его идентификатору
         * @param productionId идентификатор производства
         * @return активное производство
         */
        public function getProduction(productionId:String):ProductionVO
        {
            for each (var production:ProductionVO in productionsVO.children)
            {
                if (production.productionId == productionId)
                    return production;
            }
            return null;
        }
        
        /**
         * Получить сотрудников из указанной базы, задействованных в указаном производстве
         * @param productionId идентификатор производства, если null, возвращается для всех производств
         * @param baseId идентификатор базы, если null, возвращается для всех баз
         * @return список сотрудников
         */
        public function getEmployedEngineers(productionId:String=null, baseId:String=null):Vector.<PersonVO>
        {
            var persons:Vector.<PersonVO> = new Vector.<PersonVO>();
            var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
            var personnelDecor:PersonnelHelper = new PersonnelHelper(null, personsProxy);
            
            for each (var production:ProductionVO in productionsVO.children)
            {
                if (productionId && production.productionId != productionId)
                    continue;
                
                for each (var worker:WorkerVO in production.children)
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
                var value:ProductionsVO = appDataProxy.getChildByName(ProductionsVO.NAME) as ProductionsVO;
                
                if (!value)
                    value = new ProductionsVO();
                
                setData(value);
                
                appDataProxy.updateChild(productionsVO);
            }
            
            return data;
        }
    }
}