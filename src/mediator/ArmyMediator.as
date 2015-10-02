package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.MobilizeUnitCmdData;
    
    import dictionary.Const;
    import dictionary.UnitsDict;
    
    import events.ArmyEvent;
    
    import helpers.ArmyHelper;
    import helpers.ConditionHelper;
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.AppDataProxy;
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    import proxy.TriggersProxy;
    
    import views.protoArmyView;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.UnitDescVO;
    import vo.UnitVO;
    
    [ResourceBundle("common")]
    
    public class ArmyMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "armyMediator";
        
        private var _armyProxy:ArmyProxy;
        private var _basesListProxy:BasesListProxy;
        private var _personsProxy:PersonsProxy;
        private var _appDataProxy:AppDataProxy;
        private var _triggersProxy:TriggersProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArmyMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        /**
         * Получить список боевых юнитов
         * @return список юнитов
         */
        public function getUnits():ArrayCollection
        {
            var units:Array = [];
            for each (var unit:UnitVO in armyProxy.armyVO.children)
            {
                units.push({
                    id: unit.unitId,
                    label: unit.unitName
                });
            }
            
            units.sortOn("label");
            return new ArrayCollection(units);
        }
        
        /**
         * Получить список юнитов, которые в настоящий момент могут быть созданы
         * @return список юнитов
         */
        public function getAvailableUnits():ArrayCollection
        {
            var units:Array = [];
            var unitsDecor:ArmyHelper = new ArmyHelper(basesListProxy, appDataProxy, personsProxy, armyProxy);
            var conditionDecor:ConditionHelper = new ConditionHelper(triggersProxy);
            
            for each (var unit:UnitDescVO in UnitsDict.getInstance().units)
            {
                if (unitsDecor.unitResourceIsAvailable(unit.unitId))
                {
                    if (conditionDecor.parseCondition(unit.unitCondition) &&
                        (unit.unitResource || unitsDecor.unitCrewIsAvailable(unit.unitId)))
                    {
                        units.push(unit);
                    }
                }
            }
            
            return new ArrayCollection(units);
        }
        
        /**
         * Список всех баз
         */
        public function getBases():ArrayCollection
        {
            var bases:Array = [];
            var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy);
            for each (var baseVO:BaseVO in basesListProxy.getBasesList())
            {
                if (modulesHelper.getSpace(ModuleDescVO.HOUSING, baseVO) > 0)
                    bases.push(baseVO);
            }
            
            bases.sortOn("baseName");
            return new ArrayCollection(bases);
        }
        
        /**
         * Сгенерировать имя для юнита
         * @param unitId идентификатор описания юнита
         */
        public function generateName(unitId:String):String
        {
            var unitDesc:UnitDescVO = UnitsDict.getInstance().getUnit(unitId);
            if (!unitDesc)
                return Const.NO_TEXT;
            
            if (unitDesc.unitCrew == 1)
            {
                var soldiers:ArrayCollection = getSoldiers();
                return soldiers && soldiers.length > 0 ? unitDesc.unitName + " " + PersonVO(soldiers[0]).personName : unitDesc.unitName;
            }
            
            var stuff:Object = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)).stuff;
            var unitNum:int = int(stuff.unitCounter) + 1;
            stuff.unitCounter = unitNum;
            return unitDesc.unitName + " #" + unitNum;
        }
        
        /**
         * Получить список солдат
         * @return список солдат
         */
        public function getSoldiers():ArrayCollection
        {
            var res:Array = [];
            for each (var person:PersonVO in (new ArmyHelper(basesListProxy, appDataProxy, personsProxy, armyProxy)).getFreeSoldiers())
                res.push(person);
            return new ArrayCollection(res);
        }
        
        protected function get armyView():protoArmyView
        {
            return viewComponent as protoArmyView;
        }
        
        protected function get armyProxy():ArmyProxy
        {
            if (!_armyProxy)
                _armyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
            return _armyProxy;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!armyView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            armyView.removeEventListener(ArmyEvent.EQUIP, equipUnitHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!armyView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            armyView.addEventListener(ArmyEvent.EQUIP, equipUnitHandler);
            
            // /TODO
        }
        
        protected function get basesListProxy():BasesListProxy
        {
            if (!_basesListProxy)
                _basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            
            return _basesListProxy;
        }
        
        protected function get appDataProxy():AppDataProxy
        {
            if (!_appDataProxy)
                _appDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
            
            return _appDataProxy;
        }
        
        private function get triggersProxy():TriggersProxy
        {
            if (!_triggersProxy)
                _triggersProxy = TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME));
            return _triggersProxy;
        }
        
        protected function get personsProxy():PersonsProxy
        {
            if (!_personsProxy)
                _personsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
            
            return _personsProxy;
        }
        
        /**
         * Экипировать юнит
         * @param event событие
         */
        private function equipUnitHandler(event:ArmyEvent):void
        {
            var crew:Vector.<String> = new Vector.<String>();
            for each (var id:String in event.crew)
                crew.push(id);
            
            sendNotification(Const.MOBILIZE_UNIT, new MobilizeUnitCmdData(event.unitId, event.name, crew, event.baseId));
        }
        
        //----------------------------------
        //  Mediator
        //----------------------------------
        
        override public function setViewComponent(viewComponent:Object):void
        {
            releaseViewComponent();
            super.setViewComponent(viewComponent);
            applyViewComponent();
        }
        
        override public function listNotificationInterests():Array
        {
            return [ Const.UNIT_IS_MOBILIZED, Const.DESTROY_UNIT ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.UNIT_IS_MOBILIZED:
                    if (armyView)
                    {
                        armyView.updateList();
                        armyView.selectUnit(notification.getBody().toString());
                    }
                    break;
                case Const.DESTROY_UNIT:
                    if (armyView)
                        armyView.updateList();
                    break;
            }
        }
    }
}