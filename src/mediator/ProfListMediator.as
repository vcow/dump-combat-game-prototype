package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.CharacteristicsDict;
    import dictionary.Const;
    
    import events.EmployeeListEvent;
    
    import helpers.ModulesHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.AppDataProxy;
    import proxy.BasesListProxy;
    
    import views.protoProfessionsView;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.PriceVO;
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
        
        /**
         * Первая попавшаяся база, где есть место для размещения нового сотрудника
         */
        public function get base():BaseVO
        {
            var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy, appDataProxy);
            for each (var baseVO:BaseVO in basesListProxy.getBasesList())
            {
                if (modulesHelper.getSpace(ModuleDescVO.HOUSING, baseVO) > 0)
                    return baseVO;
            }
            
            return null;
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
            
            professionsView.addEventListener(EmployeeListEvent.HIRE, hireEmployeeHandler, false, 0, true);
            
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
            
            professionsView.removeEventListener(EmployeeListEvent.HIRE, hireEmployeeHandler);
            
            // /TODO
        }
        
        /**
         * Запрос на найм нового сотрудника
         * @param event событие
         */
        private function hireEmployeeHandler(event:EmployeeListEvent):void
        {
            var profession:ProfessionDescVO = CharacteristicsDict.getInstance().getProfession(event.professionId);
            
            if (!profession)
                return;
            
            var price:PriceVO = profession.professionHiringCost;
            if (price && !(new ResourcesHelper(basesListProxy, appDataProxy)).isEnoughResources(price))
            {
                // TODO: Отправить на докупку ресурсов
                return;
            }
            
            if (event.employeeName)
            {
                var person:PersonVO = new PersonVO();
                person.personName = event.employeeName;
                person.personImage = event.employeeImage;
                person.personGender = event.employeeGender;
                person.personProfessionId = profession.professionId;
                
                sendNotification(Const.CREATE_NEW_PERSON, person);
            }
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
            return [ Const.NEW_PERSON_CREATED, Const.EMPLOYEE_IS_HIRED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.NEW_PERSON_CREATED:
                    // Создан новый пероснаж, приписать его к первой попавшейся базе
                    break;
                case Const.EMPLOYEE_IS_HIRED:
                    // Нанят новый сотрудник
                    break;
            }
        }
    }
}