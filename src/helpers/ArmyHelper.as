package helpers
{
    import dictionary.UnitsDict;
    
    import facade.ProtoFacade;
    
    import proxy.AppDataProxy;
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import vo.BaseVO;
    import vo.GarrisonVO;
    import vo.MercenaryVO;
    import vo.PersonVO;
    import vo.ProfessionDescVO;
    import vo.UnitDescVO;
    import vo.UnitVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор боевых юнитов
     * 
     */
    
    public class ArmyHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _basesListProxy:BasesListProxy;
        private var _appDataProxy:AppDataProxy;
        private var _personsProxy:PersonsProxy;
        private var _armyProxy:ArmyProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArmyHelper(basesListProxy:BasesListProxy=null, appDataProxy:AppDataProxy=null,
                                    personsProxy:PersonsProxy=null, armyProxy:ArmyProxy=null)
        {
            _basesListProxy = basesListProxy;
            _appDataProxy = appDataProxy;
            _personsProxy = personsProxy;
            _armyProxy = armyProxy;
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
        
        private function get armyProxy():ArmyProxy
        {
            if (!_armyProxy)
                _armyProxy = ArmyProxy(ProtoFacade.getInstance().retrieveProxy(ArmyProxy.NAME));
            return _armyProxy;
        }
        
        /**
         * Получить юнит указанного солдата
         * @param personId идентификатор солдата
         * @return юнит, в экипаже которого состоит солдат
         */
        public function getUnitBySoldier(personId:String):UnitVO
        {
            for each (var unit:UnitVO in armyProxy.armyVO.children)
            {
                for each (var soldierId:String in unit.unitCrew)
                {
                    if (soldierId == personId)
                        return unit;
                }
            }
            return null;
        }
        
        /**
         * Найти базу приписки юнита
         * @param unitId идентификатор юнита
         * @return база приписки
         */
        public function getUnitPlace(unitId:String):BaseVO
        {
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                for each (var mercenary:MercenaryVO in base.baseGarrison.children)
                {
                    if (mercenary.mercenaryUnitId == unitId)
                        return base;
                }
            }
            return null;
        }
        
        /**
         * Получить список немобилизованных солдат
         * @return список немобилизованных солдат
         */
        public function getFreeSoldiers():Vector.<PersonVO>
        {
            var personnel:Vector.<PersonVO> = armyProxy.getCalledUpSoldiers();
            var soldiers:Vector.<PersonVO> = (new PersonnelHelper()).getEmployees(ProfessionDescVO.SOLGIER);
            for each (var employee:PersonVO in personnel)
            {
                for (var i:int = 0; i < soldiers.length; i++)
                {
                    if (soldiers[i].personId == employee.personId)
                    {
                        soldiers.splice(i, 1);
                        break;
                    }
                }
            }
            return soldiers;
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
            
            var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy);
            return resourcesDecor.isEnoughResources(resourcesDecor.joinResource(unit.unitResource, 1));
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
            
            return new ArmyHelper(basesListProxy, appDataProxy, personsProxy, armyProxy).getFreeSoldiers().length >= unit.unitCrew;
        }
        
        /**
         * Проверяет, является ли персонаж призванным солдатом
         * @param personId идентификатор персонажа
         * @param baseId идентификатор базы, в гарнизоне которой ищется персонаж, если null, ищется во всех базах
         * @return true, если персонаж состоит в экипаже боевого юнита
         */
        public function isDraftedIntoTheArmy(personId:String, baseId:String=null):Boolean
        {
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                if (!baseId || baseId && base.baseId == baseId)
                {
                    var garrison:GarrisonVO = base.baseGarrison;
                    
                    if (!garrison)
                        continue;
                    
                    for each (var mercenary:MercenaryVO in garrison.children)
                    {
                        var unit:UnitVO = armyProxy.getUnit(mercenary.mercenaryUnitId);
                        if (unit)
                        {
                            for each (var soldier:String in unit.unitCrew)
                            {
                                if (soldier == personId)
                                    return true;
                            }
                        }
                    }
                    
                    if (baseId)
                        break;
                }
            }
            return false;
        }
    }
}