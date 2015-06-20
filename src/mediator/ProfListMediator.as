package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.CharacteristicsDict;
    import dictionary.Const;
    
    import events.EmployeeListEvent;
    
    import helpers.ModulesHelper;
    import helpers.PersonnelHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.AppDataProxy;
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import views.protoProfessionsView;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
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
        private var _personsProxy:PersonsProxy;
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
         * Получить идентификатор базы приписки для указанного сотрудника
         * @param personId идентификатор персонажа сотрудника
         * @return идентификатор базы приписки
         */
        public function getEmployeePlace(personId:String):String
        {
            var base:BaseVO = new PersonnelHelper(basesListProxy, personsProxy).getEmployeePlace(personId);
            return base ? base.baseId : null;
        }
        
        /**
         * Первая попавшаяся база, где есть место для размещения нового сотрудника
         */
        public function get base():BaseVO
        {
            var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy);
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
        
        protected function get personsProxy():PersonsProxy
        {
            if (!_personsProxy)
                _personsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
            
            return _personsProxy;
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!professionsView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            var freeSpace:int = (new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING);
            professionsView.hireNewEmployeeAvailable = freeSpace > 0;
            
            var profs:Array = [];
            for each (var profession:ProfessionDescVO in CharacteristicsDict.getInstance().professions)
                profs.push(profession);
            professionsView.professionsList = new ArrayCollection(profs);
            
            professionsView.addEventListener(EmployeeListEvent.CREATE_PERSON, createPersonHandler, false, 0, true);
            professionsView.addEventListener(EmployeeListEvent.PLACE_EMPLOYEE, placeEmployeeHandler, false, 0, true);
            
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
            
            professionsView.removeEventListener(EmployeeListEvent.CREATE_PERSON, createPersonHandler);
            professionsView.removeEventListener(EmployeeListEvent.PLACE_EMPLOYEE, placeEmployeeHandler);
            
            // /TODO
        }
        
        /**
         * Запрос на создание нового сотрудника
         * @param event событие
         */
        private function createPersonHandler(event:EmployeeListEvent):void
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
        
        /**
         * Запрос на перемещение сотрудника на другую базу
         * @param event событие
         */
        private function placeEmployeeHandler(event:EmployeeListEvent):void
        {
            var person:PersonVO = personsProxy.getPersonById(event.employeeId);
            if (person)
                sendNotification(Const.PLACE_EMPLOYEE, person, event.baseId);
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
            return [ Const.NEW_PERSON_CREATED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.NEW_PERSON_CREATED:
                    // Создан новый пероснаж, приписать его к первой попавшейся базе
                    var person:PersonVO = notification.getBody() as PersonVO;
                    var base:BaseVO = this.base;
                    if (person && base)
					{
                        sendNotification(Const.PLACE_EMPLOYEE, person, base.baseId);
						
						var freeSpace:int = (new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING);
						professionsView.hireNewEmployeeAvailable = freeSpace > 0;
						
						if (basesDataProvider.length > 1)
							professionsView.moveEmployee(person.personId);
					}
                    break;
            }
        }
    }
}