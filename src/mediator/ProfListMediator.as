package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.CharacteristicsDict;
    
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.AppDataProxy;
    import proxy.BasesListProxy;
    
    import views.protoProfessionsView;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
    import vo.ProfessionDescVO;
    
    public class ProfListMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "professionsMediator";
        
        private var _basesListProxy:BasesListProxy;
        private var _appDataProxy:AppDataProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProfListMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            applyViewComponent();
        }
        
        /**
         * Источник данных для списка баз
         */
        public function get basesDataProvider():ArrayCollection
        {
            var bases:Array = [];
            var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy, appDataProxy);
            for each (var baseVO:BaseVO in basesListProxy.getBasesList())
            {
                if (modulesHelper.getSpace(ModuleDescVO.HOUSING, baseVO) > 0)
                    bases.push(baseVO);
            }
            
            bases.sortOn("baseName");
            return new ArrayCollection(bases);
        }
        
        protected function get professionsView():protoProfessionsView
        {
            return viewComponent as protoProfessionsView;
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
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!professionsView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            var freeSpace:int = (new ModulesHelper(basesListProxy, appDataProxy)).getSpace(ModuleDescVO.HOUSING);
            professionsView.hireNewEmployeeAvailable = freeSpace > 0;
            
            var profs:Array = [];
            for each (var profession:ProfessionDescVO in CharacteristicsDict.getInstance().professions)
                profs.push(profession);
            professionsView.professionsList = new ArrayCollection(profs);
            
            // /TODO
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!professionsView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
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
    }
}