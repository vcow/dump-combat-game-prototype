package helpers
{
    import facade.ProtoFacade;
    
    import proxy.InvestigationsProxy;
    
    import vo.PersonVO;
    import vo.ProfessionDescVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор исследований
     * 
     */
    
    public class InvestigationsHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _investigationsProxy:InvestigationsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function InvestigationsHelper(investigationsProxy:InvestigationsProxy=null)
        {
            _investigationsProxy = investigationsProxy || InvestigationsProxy(ProtoFacade.getInstance().retrieveProxy(InvestigationsProxy.NAME));
        }
        
        /**
         * Получить список всех незадействованных в исследованиях ученых
         * @return список свободных ученых
         */
        public function getFreeScientists():Vector.<PersonVO>
        {
            var personnel:Vector.<PersonVO> = _investigationsProxy.getEmployedScientists();
            var scientists:Vector.<PersonVO> = (new PersonnelHelper()).getEmployees(ProfessionDescVO.SCIENTIST);
            for each (var employee:PersonVO in personnel)
            {
                for (var i:int = 0; i < scientists.length; i++)
                {
                    if (scientists[i].personId == employee.personId)
                    {
                        scientists.splice(i, 1);
                        break;
                    }
                }
            }
            return scientists;
        }
    }
}