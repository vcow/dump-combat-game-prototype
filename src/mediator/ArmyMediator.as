package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.ArmamentDict;
    import dictionary.UnitsDict;
    
    import helpers.PersonnelHelper;
    import helpers.UnitsHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.ArmyProxy;
    
    import views.protoArmyView;
    
    import vo.ArmorDescVO;
    import vo.PersonVO;
    import vo.ProfessionDescVO;
    import vo.UnitDescVO;
    import vo.UnitVO;
    import vo.WeaponDescVO;
    
    [ResourceBundle("common")]
    
    public class ArmyMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "armyMediator";
        
        private var _armyProxy:ArmyProxy;
        
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
                
            }
            return new ArrayCollection(units);
        }
        
        /**
         * Получить список юнитов, которые в настоящий момент могут быть созданы
         * @return список юнитов
         */
        public function getAvailableUnits():ArrayCollection
        {
            var units:Array = [];
            var unitsDecor:UnitsHelper = new UnitsHelper();
            
            for each (var unit:UnitDescVO in UnitsDict.getInstance().units)
            {
                if (unitsDecor.unitResourceIsAvailable(unit.unitId))
                {
                    if (unit.unitResource || unitsDecor.unitCrewIsAvailable(unit.unitId))
                        units.push(unit);
                }
            }
            
            return new ArrayCollection(units);
        }
        
        /**
         * Получить список оружия для указанного юнита
         * @param unitId идентификатор юнита
         * @return список оружия
         */
        public function getWeaponFor(unitId:String):ArrayCollection
        {
            var res:Array = [];
            for each (var weapon:WeaponDescVO in ArmamentDict.getInstance().getWeaponForUnit(unitId))
                res.push(weapon);
            return new ArrayCollection(res);
        }
        
        /**
         * Получить список брони для указанного юнита
         * @param unitId идентификатор юнита
         * @return список брони
         */
        public function getArmorFor(unitId:String):ArrayCollection
        {
            var res:Array = [];
            for each (var armor:ArmorDescVO in ArmamentDict.getInstance().getArmorForUnit(unitId))
                res.push(armor);
            return new ArrayCollection(res);
        }
        
        /**
         * Получить список солдат
         * @return список солдат
         */
        public function getSoldiers():ArrayCollection
        {
            var res:Array = [];
            for each (var person:PersonVO in (new PersonnelHelper()).getEmployees(ProfessionDescVO.SOLGIER))
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
            
            
            // /TODO
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
            return [  ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
            }
        }
    }
}