package helpers
{
    import dictionary.UnitsDict;
    
    import facade.ProtoFacade;
    
    import proxy.AppDataProxy;
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import vo.PriceVO;
    import vo.ProfessionDescVO;
    import vo.ResourceVO;
    import vo.UnitDescVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор боевых юнитов
     * 
     */
    
    public class UnitsHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _basesListProxy:BasesListProxy;
        private var _appDataProxy:AppDataProxy;
        private var _personsProxy:PersonsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function UnitsHelper(basesListProxy:BasesListProxy=null, appDataProxy:AppDataProxy=null, personsProxy:PersonsProxy=null)
        {
            _basesListProxy = basesListProxy;
            _appDataProxy = appDataProxy;
            _personsProxy = personsProxy;
        }
        
        private function get basesListProxy():BasesListProxy
        {
            if (!_basesListProxy)
                _basesListProxy = BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
            return _basesListProxy;
        }
        
        private function get appDataProxy():AppDataProxy
        {
            if (!_appDataProxy)
                _appDataProxy = AppDataProxy(ProtoFacade.getInstance().retrieveProxy(AppDataProxy.NAME));
            return _appDataProxy;
        }
        
        private function get personsProxy():PersonsProxy
        {
            if (!_personsProxy)
                _personsProxy = PersonsProxy(ProtoFacade.getInstance().retrieveProxy(PersonsProxy.NAME));
            return _personsProxy;
        }
        
        /**
         * Возвращает наличие необходимого ресурса для создания юнита
         * @param unitId идентификатор юнита
         * @return true, если в наличии имеется ресурс для создания юнита
         */
        public function unitResourceIsAvailable(unitId:String):Boolean
        {
            var unit:UnitDescVO = UnitsDict.getInstance().getUnit(unitId);
            if (!unit.unitResource)
                return true;
            
            var resource:ResourceVO = new ResourceVO();
            resource.resourceId = unit.unitResource;
            resource.resourceCount = 1;
            
            var price:PriceVO = new PriceVO();
            price.children.push(resource);
            
            return new ResourcesHelper(basesListProxy, appDataProxy).isEnoughResources(price);
        }
        
        /**
         * Возвращает наличие необходимой команды для комплектации юнита
         * @param unitId идентификатор юнита
         * @return true, если в наличии имеется достаточно солдат для формирования экипажа
         */
        public function unitCrewIsAvailable(unitId:String):Boolean
        {
            var unit:UnitDescVO = UnitsDict.getInstance().getUnit(unitId);
            if (unit.unitCrew <= 0)
                return true;
            
            return new PersonnelHelper(basesListProxy, personsProxy).getEmployees(ProfessionDescVO.SOLGIER).length >= unit.unitCrew;
        }
    }
}