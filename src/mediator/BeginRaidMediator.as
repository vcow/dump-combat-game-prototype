package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.AttackBaseCmdData;
    
    import dictionary.Const;
    
    import events.BeginRaidEvent;
    
    import helpers.ArmyHelper;
    import helpers.BattleHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    import proxy.RaidsProxy;
    
    import views.ui.BeginRaidView;
    
    import vo.BaseVO;
    import vo.IVO;
    import vo.ModifiersVO;
    import vo.RaidVO;
    import vo.TargetVO;
    import vo.UnitVO;
    
    public class BeginRaidMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "beginRaidMediator";
        
        private var _basesListProxy:BasesListProxy;
        private var _armyProxy:ArmyProxy;
        private var _raidsProxy:RaidsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function BeginRaidMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            applyViewComponent();
        }
        
        protected function get beginRaidView():BeginRaidView
        {
            return viewComponent as BeginRaidView;
        }
        
        protected function get basesListProxy():BasesListProxy
        {
            if (!_basesListProxy)
                _basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            return _basesListProxy;
        }
        
        protected function get armyProxy():ArmyProxy
        {
            if (!_armyProxy)
                _armyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
            return _armyProxy;
        }
        
        protected function get raidsProxy():RaidsProxy
        {
            if (!_raidsProxy)
                _raidsProxy = RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME));
            return _raidsProxy;
        }
        
        /**
         * Имя атакуемой базы
         */
        public function get targetName():String
        {
            if (beginRaidView)
            {
                var base:IVO = basesListProxy.getBase(beginRaidView.targetBaseId);
                if (base is BaseVO)
                    return BaseVO(base).baseName;
                if (base is TargetVO)
                    return TargetVO(base).targetName;
            }
            return Const.NO_TEXT;
        }
        
        /**
         * Флаг, указывающий на то, что целевая база уже была атакована
         */
        public function get targetAlreadyAttacked():Boolean
        {
            if (beginRaidView)
            {
                for each (var raid:RaidVO in raidsProxy.getActiveRaids())
                {
                    if (raid.raidTarget == beginRaidView.targetBaseId)
                        return true;
                }
            }
            return false;
        }
        
        /**
         * Список юнитов, годных для рейда
         */
        public function get unitsList():ArrayCollection
        {
            var list:Array = [];
            var units:Vector.<UnitVO> = (new ArmyHelper(basesListProxy, null, null, armyProxy)).getUnitsOnBase();
            var battleDecor:BattleHelper = new BattleHelper();
            
            for each (var unit:UnitVO in units)
            {
                // Для рейда годятся только юниты, которые могут передвигаться
                if (battleDecor.getMaxUnitProperty(ModifiersVO.SPEED, unit))
                {
                    list.push({
                        label: unit.unitName,
                        id: unit.unitId,
                        check: false
                    });
                }
            }
            list.sortOn("label");
            return new ArrayCollection(list);
        }
        
        /**
         * Список баз игрока
         */
        public function get basesList():ArrayCollection
        {
            var list:Array = [];
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                list.push({
                    label: base.baseName,
                    id: base.baseId
                });
            }
            list.sortOn("label");
            return new ArrayCollection(list);
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!beginRaidView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            beginRaidView.removeEventListener(BeginRaidEvent.BEGIN_RAID, beginRaidHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!beginRaidView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            beginRaidView.addEventListener(BeginRaidEvent.BEGIN_RAID, beginRaidHandler);
            
            // /TODO
        }
        
        /**
         * Юзер инициировал рейд
         * @param event событие
         */
        private function beginRaidHandler(event:BeginRaidEvent):void
        {
            var army:Vector.<UnitVO> = new Vector.<UnitVO>();
            for each (var item:String in event.units)
            {
                var unit:UnitVO = armyProxy.getUnit(item);
                if (unit)
                    army.push(unit);
            }
            
            var enemiesProxy:EnemiesProxy = EnemiesProxy(this.facade.retrieveProxy(EnemiesProxy.NAME));
            sendNotification(Const.ATTACK_BASE, new AttackBaseCmdData(beginRaidView.targetBaseId,
                enemiesProxy.getOwner(beginRaidView.targetBaseId), event.departureBase, null, army));
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
            return [ Const.UNIT_DESTROYED, Const.UNIT_IS_MOBILIZED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.UNIT_DESTROYED:
                case Const.UNIT_IS_MOBILIZED:
                    if (beginRaidView)
                        beginRaidView.updateList();
                    break;
            }
        }
    }
}