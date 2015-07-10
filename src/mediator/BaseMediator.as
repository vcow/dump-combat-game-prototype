package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.RenameCmdData;
    
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import events.BaseEvent;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.BasesListProxy;
    
    import views.ui.BaseView;
    
    import vo.BaseVO;
    import vo.IVO;
    import vo.ModuleVO;
    import vo.ModulesVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Медиатор UI базы
     * 
     */
    
    public class BaseMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "baseMediator";
        
        private var _base:BaseVO;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function BaseMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            applyViewComponent();
        }
        
        /**
         * Наименование базы
         */
        public function get baseName():String
        {
            return _base ? _base.baseName : "";
        }
        
        /**
         * Список модулей базы
         */
        public function get modules():ArrayCollection
        {
            if (!_base)
                return null;
            
            var modules:Array = [];
            for each (var item:IVO in _base.children)
            {
                if (item.name == ModulesVO.NAME)
                {
                    for (var i:int = 0; i < item.children.length; i++)
                    {
                        var module:ModuleVO = ModuleVO(item.children[i]);
                        modules.push({
                            index: i,
                            label: ModulesDict.getInstance().getModule(module.moduleId).moduleName,
                            inactive: module.moduleInactive
                        });
                    }
                    break;
                }
            }
            return new ArrayCollection(modules);
        }
        
        /**
         * Максимальное количество модулей базы
         */
        public function get modulesMaxCount():int
        {
            if (_base)
            {
                var modules:Array = [];
                for each (var item:IVO in _base.children)
                {
                    if (item.name == ModulesVO.NAME)
                        return ModulesVO(item).modulesMaxCount;
                }
            }
            return 0;
        }
        
        /**
         * Идентификатор базы
         */
        public function get baseId():String
        {
            return _base ? _base.baseId : "";
        }
        
        protected function get baseView():BaseView
        {
            return viewComponent as BaseView;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!baseView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            baseView.removeEventListener(BaseEvent.RENAME, renameBaseHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!baseView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            baseView.baseName = baseName;
            baseView.modulesList = modules;
            baseView.modulesLimit = modulesMaxCount;
            
            baseView.addEventListener(BaseEvent.RENAME, renameBaseHandler);
            
            // /TODO
        }
        
        /**
         * Обработчик запроса на переименование базы
         * @param event событие
         */
        private function renameBaseHandler(event:BaseEvent):void
        {
            sendNotification(Const.RENAME_BASE, new RenameCmdData(event.baseId, event.data.toString()));
        }
        
        //----------------------------------
        //  Mediator
        //----------------------------------
        
        override public function setViewComponent(viewComponent:Object):void
        {
            releaseViewComponent();
            
            _base = viewComponent ?
                BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBaseById(viewComponent.baseId) as BaseVO : null;
            
            super.setViewComponent(viewComponent);
            applyViewComponent();
        }
        
        override public function listNotificationInterests():Array
        {
            return [ Const.BASE_RENAMED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.BASE_RENAMED:
                    if (baseView)
                        baseView.baseName = baseName;
                    break;
            }
        }
    }
}