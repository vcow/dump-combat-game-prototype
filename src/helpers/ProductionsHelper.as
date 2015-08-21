package helpers
{
    import facade.ProtoFacade;
    
    import proxy.ProductionsProxy;
    
    import vo.EmployeeVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
    import vo.ProfessionDescVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор производств
     * 
     */
    
    public class ProductionsHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _productionsProxy:ProductionsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionsHelper(productionsProxy:ProductionsProxy=null)
        {
            _productionsProxy = productionsProxy || ProductionsProxy(ProtoFacade.getInstance().retrieveProxy(ProductionsProxy.NAME));
        }
        
        /**
         * Получить список всех незадействованных в производстве инженеров
         * @return список свободных инженеров
         */
        public function getFreeEngineers():Vector.<PersonVO>
        {
            var personnel:PersonnelVO = _productionsProxy.getEmployedEngineers();
            var egineers:Vector.<PersonVO> = (new PersonnelHelper()).getEmployees(ProfessionDescVO.ENGINEER);
            for each (var engineer:EmployeeVO in personnel.children)
            {
                for (var i:int = 0; i < egineers.length; i++)
                {
                    if (egineers[i].personId == engineer.employeePersonId)
                    {
                        egineers.splice(i, 1);
                        break;
                    }
                }
            }
            return egineers;
        }
    }
}