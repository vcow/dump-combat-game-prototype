package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.BuildModuleCmdData;
    import command.data.RenameCmdData;
    
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import events.BaseEvent;
    
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.BasesListProxy;
    
    import views.ui.BaseView;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
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
        
        private var _moduleTypesList:ArrayCollection;
        
        private var _modulesDecor:ModulesHelper;
        
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
            var allModules:ModulesVO = _base.baseModules;
            if (allModules)
            {
                for each (var module:ModuleVO in allModules.children)
                {
                    modules.push({
                        id: module.moduleModuleId,
                        index: module.moduleId,
                        label: ModulesDict.getInstance().getModule(module.moduleModuleId).moduleName,
                        inactive: module.moduleInactive,
                        under_construct: Boolean(module.moduleBuildTimer)
                    });
                }
            }
            
            return new ArrayCollection(modules);
        }
        
        /**
         * Список типов модулей базы
         */
        public function get moduleTypesList():ArrayCollection
        {
            if (!_moduleTypesList)
            {
                var types:Array = [];
                for each (var module:ModuleDescVO in ModulesDict.getInstance().modules)
                {
                    types.push({
                        label: module.moduleName,
                        id: module.moduleId,
                        price: module.modulePrice,
                        leadTime: module.moduleLeadTime
                    });
                }
                _moduleTypesList = new ArrayCollection(types);
            }
            return _moduleTypesList;
        }
        
        /**
         * Максимальное количество модулей базы
         */
        public function get modulesMaxCount():int
        {
            if (_base)
            {
                var modules:ModulesVO = _base.baseModules;
                return modules ? modules.modulesMaxCount : 0;
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
            baseView.removeEventListener(BaseEvent.CREATE_MODULE, createModuleHandler);
            baseView.removeEventListener(BaseEvent.REMOVE_MODULE, removeModuleHandler);
            
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
            baseView.buildModulePopUp.modulesList = moduleTypesList;
            baseView.numStores = modulesDecor.getModulesCount(ModuleDescVO.STORE);
            
            baseView.addEventListener(BaseEvent.RENAME, renameBaseHandler);
            baseView.addEventListener(BaseEvent.CREATE_MODULE, createModuleHandler);
            baseView.addEventListener(BaseEvent.REMOVE_MODULE, removeModuleHandler);
            
            // /TODO
        }
        
        protected function get modulesDecor():ModulesHelper
        {
            if (!_modulesDecor)
                _modulesDecor = new ModulesHelper();
            return _modulesDecor;
        }
        
        /**
         * Обработчик запроса на переименование базы
         * @param event событие
         */
        private function renameBaseHandler(event:BaseEvent):void
        {
            sendNotification(Const.RENAME_BASE, new RenameCmdData(event.baseId, event.data.toString()));
        }
        
        /**
         * Запрос на постройку нового модуля
         * @param event событие
         */
        private function createModuleHandler(event:BaseEvent):void
        {
            var module:ModuleDescVO = ModulesDict.getInstance().getModule(event.data.toString());
            if (module)
                sendNotification(Const.BUILD_MODULE, new BuildModuleCmdData(event.baseId, module.moduleId));
        }
        
        /**
         * Запрос на удалений модуля
         * @param event событие
         */
        private function removeModuleHandler(event:BaseEvent):void
        {
            if (_base)
            {
                var modules:ModulesVO = _base.baseModules;
                if (modules)
                {
                    for each (var module:ModuleVO in modules.children)
                    {
                        if (module.moduleId == event.data)
                        {
                            sendNotification(Const.REMOVE_MODULE, module.moduleId);
                            return;
                        }
                    }
                }
            }
        }
        
        //----------------------------------
        //  Mediator
        //----------------------------------
        
        override public function setViewComponent(viewComponent:Object):void
        {
            releaseViewComponent();
            
            _base = viewComponent ?
                BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBase(viewComponent.baseId) as BaseVO : null;
            
            super.setViewComponent(viewComponent);
            applyViewComponent();
        }
        
        override public function listNotificationInterests():Array
        {
            return [ Const.BASE_RENAMED, Const.MODULES_CHANGED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.BASE_RENAMED:
                    if (notification.getBody() == _base && baseView)
                        baseView.baseName = baseName;
                    break;
                case Const.MODULES_CHANGED:
                    if (baseView)
                    {
                        if (notification.getBody() == _base)
                            baseView.modulesList = modules;
                        
                        baseView.numStores = modulesDecor.getModulesCount(ModuleDescVO.STORE);
                    }
                    break;
            }
        }
    }
}