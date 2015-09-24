package mediator
{
    import mx.collections.ArrayCollection;
    import mx.resources.ResourceManager;
    
    import command.data.SelectWeaponCmdData;
    
    import dictionary.ArmamentDict;
    import dictionary.Const;
    
    import events.UnitEvent;
    
    import helpers.ConditionHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.AppDataProxy;
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.TriggersProxy;
    
    import views.ui.UnitView;
    
    import vo.ArmorDescVO;
    import vo.UnitDescVO;
    import vo.UnitVO;
    import vo.WeaponDescVO;
    import vo.WeaponVO;
    
    [ResourceBundle("common")]
    
    public class UnitMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "unitMediator";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _unit:UnitVO;
        
        private var _armyProxy:ArmyProxy;
        private var _basesListProxy:BasesListProxy;
        private var _appDataProxy:AppDataProxy;
        private var _triggersProxy:TriggersProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function UnitMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        /**
         * Идентификатор юнита
         */
        public function set unitId(value:String):void
        {
            if (_unit && _unit.unitId == value)
                return;
            
            _unit = armyProxy.getUnit(value);
        }
        
        /**
         * Флаг, указывающий на то, что юнит является солдатом а не техникой
         */
        public function get isSoldier():Boolean
        {
            return !(_unit && _unit.unitDesc.unitResource);
        }
        
        /**
         * Наименование юнита
         */
        public function get unitName():String
        {
            return _unit ? _unit.unitName : Const.NO_TEXT;
        }
        
        /**
         * Описание юнита
         */
        public function get unitDesc():UnitDescVO
        {
            return _unit ? _unit.unitDesc : null;
        }
        
        /**
         * Получить список оружия
         * @param slot слдот, для которого получается оружие
         * @return список оружия
         */
        public function getAvailableWeaponFor(slot:int):ArrayCollection
        {
            var res:Array = [];
            var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, appDataProxy);
            var conditionDecor:ConditionHelper = new ConditionHelper(triggersProxy);
            var selected:WeaponVO = getWeapon(slot);
            var weaponFound:Boolean = !selected;
            
            if (_unit)
            {
                for each (var weapon:WeaponDescVO in ArmamentDict.getInstance().getWeaponForUnit(_unit.unitUnitId))
                {
                    if (!resourcesDecor.isEnoughResources(resourcesDecor.joinResource(weapon.weaponResource, 1)))
                        continue;   // Такого оружия нет на складах
                    
                    if (weapon.weaponSlot.length > 0 && weapon.weaponSlot.indexOf(slot) == -1)
                        continue;   // Не подходит для этого слота
                    
                    if (!conditionDecor.parseCondition(weapon.weaponCondition))
                        continue;   // Не выполняется условие использования оружия
                    
                    res.push({
                        id: weapon.weaponId,
                        label: weapon.resourceDesc.resourceName,
                        loadable: weapon.weaponClip > 0
                    });
                    
                    if (!weaponFound)
                        weaponFound ||= selected.weaponId == weapon.weaponId;
                }
                
                if (!weaponFound)
                {
                    // Добавить в список то оружие, которое сейчас лежит в слоте
                    res.push({
                        id: selected.weaponDesc.weaponId,
                        label: selected.weaponDesc.resourceDesc.resourceName,
                        loadable: selected.weaponDesc.weaponClip > 0
                    });
                }
                
                res.sortOn("label");
            }
            
            return new ArrayCollection(res);
        }
        
        /**
         * Текущее оружие на юните
         */
        public function getWeapon(slot:int):WeaponVO
        {
            if (_unit)
            {
                for each (var weapon:WeaponVO in _unit.unitWeapon)
                {
                    for each (var s:int in weapon.weaponSlot)
                    {
                        if (s == slot)
                            return weapon;
                    }
                }
            }
            return null;
        }
        
        /**
         * Получить список брони
         * @return список брони
         */
        public function getArmor():ArrayCollection
        {
            var res:Array = [ {
                id: "",
                label: ResourceManager.getInstance().getString("common", isSoldier ? "army.unit.soldier.notarmored" : "army.unit.notarmored")
            } ];
            
            var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, appDataProxy);
            
            if (_unit)
            {
                for each (var armor:ArmorDescVO in ArmamentDict.getInstance().getArmorForUnit(_unit.unitUnitId))
                {
                    if (!resourcesDecor.isEnoughResources(resourcesDecor.joinResource(armor.armorResource, 1)))
                        continue;   // Такой брони нет на складах
                    
                    res.push({
                        id: armor.armorId,
                        label: armor.resourceDesc.resourceName
                    });
                }
            }
            
            return new ArrayCollection(res);
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
        
        protected function get armyProxy():ArmyProxy
        {
            if (!_armyProxy)
                _armyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
            return _armyProxy;
        }
        
        protected function get triggersProxy():TriggersProxy
        {
            if (!_triggersProxy)
                _triggersProxy = TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME));
            return _triggersProxy;
        }
        
        protected function get unitView():UnitView
        {
            return viewComponent as UnitView;
        }
        
        /**
         * На одном из слотов выбрано оружие
         * @param event событие
         */
        private function selectWeaponHandler(event:UnitEvent):void
        {
            if (!_unit)
                return;
            
            var weapon:WeaponDescVO = ArmamentDict.getInstance().getWeapon(event.itemId);
            sendNotification(Const.SELECT_WEAPON, new SelectWeaponCmdData(_unit.unitId, event.slotNum, weapon ? weapon.weaponId : ""));
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!unitView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            unitView.removeEventListener(UnitEvent.SELECT_WEAPON, selectWeaponHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!unitView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            unitView.addEventListener(UnitEvent.SELECT_WEAPON, selectWeaponHandler);
            
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
            return [ Const.WEAPON_SELECTED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.WEAPON_SELECTED:
                    if (unitView && unitView.unitId == notification.getBody().toString())
                        unitView.updateUnit();
                    break;
            }
        }
    }
}