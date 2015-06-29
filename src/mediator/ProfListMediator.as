package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.HirePersonCmdData;
    
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
		
		/**
		 * Вернуть данные по сотрудникам указанной профессии
		 * @param professionId идентификатор професии, если 0, возвращаются все сотрудники
		 * @return данные по сотрудникам
		 */
		public function getEmployeeData(professionId:int=0):ArrayCollection
		{
			var personnelDecor:PersonnelHelper = new PersonnelHelper(basesListProxy, personsProxy);
			var employeeData:Array = [];
			
			for each (var person:PersonVO in personnelDecor.getEmployees(professionId))
			{
				var item:Object = { label: person.personName, personId: person.personId };
				employeeData.push(item); 
				
				var base:BaseVO = personnelDecor.getEmployeePlace(person.personId);
				if (base)
				{
					item.base = base.baseName;
					item.baseId = base.baseId;
				}
			}
			employeeData.sortOn("label");
			return employeeData.length > 0 ? new ArrayCollection(employeeData) : null;
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
			
            professionsView.hireEmployePopUp.professionsList = new ArrayCollection(profs);
			professionsView.hireEmployePopUp.defaultProfession = ProfessionDescVO.LABORER;
            
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
				
                sendNotification(Const.CREATE_NEW_PERSON, new HirePersonCmdData(person, base.baseId, profession.professionId));
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
                sendNotification(Const.PLACE_EMPLOYEE, new HirePersonCmdData(person, event.baseId, event.professionId));
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
            return [ Const.NEW_PERSON_CREATED, Const.EMPLOYEE_IS_PLACED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.NEW_PERSON_CREATED:
                    // Создан новый пероснаж
                    var person:PersonVO = notification.getBody() as PersonVO;
                    if (person)
					{
						var freeSpace:int = (new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING);
						professionsView.hireNewEmployeeAvailable = freeSpace > 0;
						
						if (basesDataProvider.length > 1)
                        {
                            // Открыть UI перевода на другую базу, если есть куда переводить
							professionsView.moveEmployee(person.personId);
                        }
					}
					else
					{
						professionsView.updateList();
					}
                    break;
				case Const.EMPLOYEE_IS_PLACED:
					professionsView.updateList();
					break;
            }
        }
    }
}