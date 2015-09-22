package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.MovePersonCmdData;
    
    import dictionary.Const;
    import dictionary.ProfessionsDict;
    
    import events.PersonEvent;
    
    import helpers.PersonnelHelper;
    
    import managers.PersonTemplatesManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import views.ui.PersonView;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.PersonVO;
    import vo.ProfessionDescVO;
    
    public class PersonMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "personMediator";
        
        private var _person:PersonVO;
        private var _personsProxy:PersonsProxy;
        private var _basesListProxy:BasesListProxy;
        private var _profDataProvider:ArrayCollection;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            
            PersonTemplatesManager.getInstance();
        }
        
        /**
         * Идентификатор персонажа
         */
        public function set personId(value:String):void
        {
            if (_person && _person.personId == value)
                return;
            
            _person = personsProxy.getPerson(value);
        }
        
        /**
         * Имя выбранного персонажа
         */
        public function get personName():String
        {
            return _person ? _person.personName : Const.NO_TEXT;
        }
        
        /**
         * Аватар выбранного персонажа
         */
        public function get personAvatar():String
        {
            return _person ? _person.personImage : "";
        }
        
        /**
         * База выбранного персонажа
         */
        public function get personBase():BaseVO
        {
            return _person ? (new PersonnelHelper(basesListProxy, personsProxy)).getEmployeePlace(_person.personId) : null;
        }
        
        /**
         * Идентификатор профессии выбранного персонажа
         */
        public function get personProfession():String
        {
            return _person ? _person.personProfessionId : "";
        }
        
        /**
         * Источник данных для списка баз
         */
        public function get basesDataProvider():ArrayCollection
        {
            var bases:Array = [];
            for each (var base:BaseVO in basesListProxy.getBasesList())
                bases.push(base);
            
            bases.sortOn("baseName");
            return new ArrayCollection(bases);
        }
        
        /**
         * Список профессий
         */
        public function get profDataProvider():ArrayCollection
        {
            if (!_profDataProvider)
            {
                var profs:Array = [];
                for each (var profession:ProfessionDescVO in ProfessionsDict.getInstance().professions)
                   profs.push(profession);
               _profDataProvider = new ArrayCollection(profs);
            }
            return _profDataProvider;
        }
        
        protected function get personView():PersonView
        {
            return viewComponent as PersonView;
        }
        
        protected function get personsProxy():PersonsProxy
        {
            if (!_personsProxy)
                _personsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
            return _personsProxy;
        }
        
        protected function get basesListProxy():BasesListProxy
        {
            if (!_basesListProxy)
                _basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            return _basesListProxy;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!personView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            personView.removeEventListener(PersonEvent.FIRE_PERSON, firePersonHandler);
            personView.removeEventListener(PersonEvent.MOVE_PERSON, movePersonHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!personView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            personView.addEventListener(PersonEvent.FIRE_PERSON, firePersonHandler);
            personView.addEventListener(PersonEvent.MOVE_PERSON, movePersonHandler);
            
            // /TODO
        }
        
        private function firePersonHandler(event:PersonEvent):void
        {
            sendNotification(Const.REPLACE_PERSON, event.personId);
        }
        
        private function movePersonHandler(event:PersonEvent):void
        {
            sendNotification(Const.MOVE_PERSON, new MovePersonCmdData(event.personId, event.baseId, event.professionId));
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
            return [ Const.PERSON_IS_REPLACED, Const.EMPLOYEE_PROF_IS_CHANGED, Const.EMPLOYEE_IS_PLACED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.PERSON_IS_REPLACED:
                    if (personView)
                    {
                        if (notification.getBody().toString() == personView.personId)
                            personView.goBack();
                    }
                    break;
                case Const.EMPLOYEE_PROF_IS_CHANGED:
                    var personId:String = notification.getBody().toString();
                    if (personView && personId == personView.personId)
                        personView.updateProfession();
                    break;
                case Const.EMPLOYEE_IS_PLACED:
                    var employee:EmployeeVO = notification.getBody() as EmployeeVO;
                    if (employee && personView && employee.employeePersonId == personView.personId)
                        personView.updateBase();
                    break;
            }
        }
    }
}