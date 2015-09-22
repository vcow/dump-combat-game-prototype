package helpers
{
    import facade.ProtoFacade;
    
    import proxy.ProductionsProxy;
    
    import vo.PersonVO;
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
            var personnel:Vector.<PersonVO> = _productionsProxy.getEmployedEngineers();
            var egineers:Vector.<PersonVO> = (new PersonnelHelper()).getEmployees(ProfessionDescVO.ENGINEER);
            for each (var engineer:PersonVO in personnel)
            {
                for (var i:int = 0; i < egineers.length; i++)
                {
                    if (egineers[i].personId == engineer.personId)
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