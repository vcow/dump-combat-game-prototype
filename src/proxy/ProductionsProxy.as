package proxy
{
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.ProductionsVO;
    import vo.PersonnelVO;
    import vo.ProductionVO;
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
         * @return список сотрудников в виде персонала базы
         */
        public function getEmployedEngineers(productionId:String=null, baseId:String=null):PersonnelVO
        {
            var personnel:PersonnelVO = new PersonnelVO;
            var personnelDecor:PersonnelHelper = new PersonnelHelper();
            
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