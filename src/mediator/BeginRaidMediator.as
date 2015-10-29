package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.Const;
    
    import helpers.ArmyHelper;
    import helpers.BattleHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    
    import views.ui.BeginRaidView;
    
    import vo.BaseVO;
    import vo.IVO;
    import vo.ModifiersVO;
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
        
        /**
         * Имя атакуемой базы
         */
        public function get targetName():String
        {
            if (beginRaidView)
            {
                var base:IVO = basesListProxy.getBase(beginRaidView.tagetBaseId);
                if (base is BaseVO)
                    return BaseVO(base).baseName;
                if (base is TargetVO)
                    return TargetVO(base).targetName;
            }
            return Const.NO_TEXT;
        }
        
        /**
         * Список юнитов, годных для рейда
         */
        public function get unitsList():ArrayCollection
        {
            var list:Array = [];
            var units:Vector.<UnitVO> = (new ArmyHelper(basesListProxy, null, null, armyProxy)).getUnitsOnBase();
            var battleDecor:BattleHelper = new BattleHelper(armyProxy);
            
            for each (var unit:UnitVO in units)
            {
                // Для рейда годятся только юниты, которые могут передвигаться
                if (battleDecor.getUnitProperty(ModifiersVO.SPEED, unit.unitId))
                {
                    list.push({
                        label: unit.unitName,
                        id: unit.unitId,
                        check: false
                    });
                }
            }
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