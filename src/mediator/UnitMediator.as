package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.ReloadItemCmdData;
    import command.data.SelectArmamentCmdData;
    
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
    
    import vo.AmmoDescVO;
    import vo.AmmoVO;
    import vo.ArmorDescVO;
    import vo.ArmorVO;
    import vo.IVO;
    import vo.PriceVO;
    import vo.ResourceVO;
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
         * @param slot слот, для которого получается оружие
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
                    
                    var unique:Boolean = weapon.weaponSlot.length <= 1 || weapon.weaponSlot[weapon.weaponSlot.length - 1] == slot;
                    res.push({
                        id: weapon.weaponId,
                        label: weapon.resourceDesc.resourceName,
                        loadable: weapon.weaponClip > 0 && unique
                    });
                    
                    if (!weaponFound)
                        weaponFound ||= selected.weaponId == weapon.weaponId;
                }
                
                if (!weaponFound)
                {
                    // Добавить в список то оружие, которое сейчас лежит в слоте
                    unique = selected.weaponDesc.weaponSlot.length <= 1 || selected.weaponDesc.weaponSlot[selected.weaponDesc.weaponSlot.length - 1] == slot;
                    res.push({
                        id: selected.weaponDesc.weaponId,
                        label: selected.weaponDesc.resourceDesc.resourceName,
                        loadable: selected.weaponDesc.weaponClip > 0 && unique
                    });
                }
                
                res.sortOn("label");
            }
            
            return new ArrayCollection(res);
        }
        
        /**
         * Получить боеприпасы для указанного оружия
         * @param slot слот, в котором лежит оружие
         * @return список боеприпасов, заряженных и доступных
         */
        public function getAmmoFor(slot:int):ArrayCollection
        {
            var res:Array = [];
            var weapon:WeaponVO = getWeapon(slot);
            if (weapon)
            {
                var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, appDataProxy);
                for each (var ammoDesc:AmmoDescVO in ArmamentDict.getInstance().getAmmoForUnit(weapon.weaponId))
                {
                    var rest:int = resourcesDecor.getResource(ammoDesc.ammoResource);
                    var loaded:int = 0;
                    for each (var ammo:AmmoVO in weapon.children)
                    {
                        if (ammo.ammoDesc.ammoResource == ammoDesc.ammoResource)
                            loaded++;
                    }
                    
                    if (rest || loaded)
                    {
                        res.push({
                            id: ammoDesc.ammoId,
                            label: ammoDesc.resourceDesc.resourceName,
                            loaded: loaded,
                            rest: rest
                        });
                    }
                }
            }
            return new ArrayCollection(res);
        }
        
        /**
         * Получить боеприпасы для юнита
         * @return список боеприпасов, заряженных и доступных
         */
        public function getAmmoForUnit():ArrayCollection
        {
            var res:Array = [];
            if (_unit)
            {
                var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, appDataProxy);
                for each (var ammoDesc:AmmoDescVO in ArmamentDict.getInstance().getAmmoForUnit(_unit.unitUnitId))
                {
                    var rest:int = resourcesDecor.getResource(ammoDesc.ammoResource);
                    var loaded:int = 0;
                    for each (var item:IVO in _unit.children)
                    {
                        if (item.name == AmmoVO.NAME)
                        {
                            var ammo:AmmoVO = AmmoVO(item);
                            if (ammo.ammoDesc.ammoResource == ammoDesc.ammoResource)
                                loaded++;
                        }
                    }
                    
                    if (rest || loaded)
                    {
                        res.push({
                            id: ammoDesc.ammoId,
                            label: ammoDesc.resourceDesc.resourceName,
                            loaded: loaded,
                            rest: rest
                        });
                    }
                }
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
         * @param slot слот, для которого получается броня
         * @return список брони
         */
        public function getAvailableArmorFor(slot:int):ArrayCollection
        {
            var res:Array = [];
            var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, appDataProxy);
            var conditionDecor:ConditionHelper = new ConditionHelper(triggersProxy);
            var selected:ArmorVO = getArmor(slot);
            var armorFound:Boolean = !selected;
            
            if (_unit)
            {
                for each (var armor:ArmorDescVO in ArmamentDict.getInstance().getArmorForUnit(_unit.unitUnitId))
                {
                    if (!resourcesDecor.isEnoughResources(resourcesDecor.joinResource(armor.armorResource, 1)))
                        continue;   // Такой брони нет на складах
                    
                    if (armor.armorSlot.length > 0 && armor.armorSlot.indexOf(slot) == -1)
                        continue;   // Не подходит для этого слота
                    
                    if (!conditionDecor.parseCondition(armor.armorCondition))
                        continue;   // Не выполняется условие использования оружия
                    
                    var unique:Boolean = armor.armorSlot.length <= 1 || armor.armorSlot[armor.armorSlot.length - 1] == slot;
                    res.push({
                        id: armor.armorId,
                        label: armor.resourceDesc.resourceName
                    });
                    
                    if (!armorFound)
                        armorFound ||= selected.armorId == armor.armorId;
                }
                
                if (!armorFound)
                {
                    // Добавить в список то оружие, которое сейчас лежит в слоте
                    res.push({
                        id: selected.armorDesc.armorId,
                        label: selected.armorDesc.resourceDesc.resourceName
                    });
                }
                
                res.sortOn("label");
            }
            
            return new ArrayCollection(res);
        }
        
        /**
         * Получить список брони
         * @return список брони
         */
        public function getArmor(slot:int):ArmorVO
        {
            if (_unit)
            {
                for each (var armor:ArmorVO in _unit.unitArmor)
                {
                    for each (var s:int in armor.armorSlot)
                    {
                        if (s == slot)
                            return armor;
                    }
                }
            }
            return null;
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
            sendNotification(Const.SELECT_WEAPON, new SelectArmamentCmdData(_unit.unitId, event.slot, weapon ? weapon.weaponId : ""));
        }
        
        /**
         * Оружие перезаряжается
         * @param event событие
         */
        private function chargeWeaponHandler(event:UnitEvent):void
        {
            if (!_unit)
                return;
            
            var ammo:PriceVO = new PriceVO();
            for each (var item:Object in event.ammo)
            {
                var ammoDesc:AmmoDescVO = ArmamentDict.getInstance().getAmmo(item.id);
                if (!ammoDesc || item.loaded == 0)
                    continue;
                
                var resource:ResourceVO = new ResourceVO();
                resource.resourceId = ammoDesc.ammoResource;
                resource.resourceCount = item.loaded;
                ammo.children.push(resource);
            }
            
            sendNotification(Const.RELOAD_WEAPON, new ReloadItemCmdData(_unit.unitId, ammo, event.slot));
        }
        
        /**
         * Выбрана броня
         * @param event событие
         */
        private function selectArmorHandler(event:UnitEvent):void
        {
            if (!_unit)
                return;
            
            var armor:ArmorDescVO = ArmamentDict.getInstance().getArmor(event.itemId);
            sendNotification(Const.SELECT_ARMOR, new SelectArmamentCmdData(_unit.unitId, event.slot, armor ? armor.armorId : ""));
        }
        
        /**
         * Заряжается юнит
         * @param event событие
         */
        private function chargeUnitHandler(event:UnitEvent):void
        {
            if (!_unit)
                return;
            
            var ammo:PriceVO = new PriceVO();
            for each (var item:Object in event.ammo)
            {
                var ammoDesc:AmmoDescVO = ArmamentDict.getInstance().getAmmo(item.id);
                if (!ammoDesc || item.loaded == 0)
                    continue;
                
                var resource:ResourceVO = new ResourceVO();
                resource.resourceId = ammoDesc.ammoResource;
                resource.resourceCount = item.loaded;
                ammo.children.push(resource);
            }
            
            sendNotification(Const.RELOAD_UNIT, new ReloadItemCmdData(_unit.unitId, ammo));
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
            unitView.removeEventListener(UnitEvent.CHARGE_WEAPON, chargeWeaponHandler);
            unitView.removeEventListener(UnitEvent.SELECT_ARMOR, selectArmorHandler);
            unitView.removeEventListener(UnitEvent.CHARGE_UNIT, chargeUnitHandler);
            
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
            unitView.addEventListener(UnitEvent.CHARGE_WEAPON, chargeWeaponHandler);
            unitView.addEventListener(UnitEvent.SELECT_ARMOR, selectArmorHandler);
            unitView.addEventListener(UnitEvent.CHARGE_UNIT, chargeUnitHandler);
            
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
            return [ Const.WEAPON_SELECTED, Const.ARMOR_SELECTED, Const.UNIT_RELOADED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.WEAPON_SELECTED:
                case Const.ARMOR_SELECTED:
                    if (unitView && unitView.unitId == notification.getBody().toString())
                        unitView.updateUnit();
                    break;
                case Const.UNIT_RELOADED:
                    break;
            }
        }
    }
}