package helpers
{
    import facade.ProtoFacade;
    
    import proxy.InvestigationsProxy;
    
    import vo.EmployeeVO;
    import vo.PersonVO;
    import vo.PersonnelVO;
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
            var personnel:PersonnelVO = _investigationsProxy.getEmployedScientists();
            var scientists:Vector.<PersonVO> = (new PersonnelHelper()).getEmployees(ProfessionDescVO.SCIENTIST);
            for each (var employee:EmployeeVO in personnel.children)
            {
                for (var i:int = 0; i < scientists.length; i++)
                {
                    if (scientists[i].personId == employee.employeePersonId)
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