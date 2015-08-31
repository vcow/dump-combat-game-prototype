package mediator
{
    import dictionary.Const;
    
    import helpers.PersonnelHelper;
    
    import managers.PersonTemplatesManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.PersonsProxy;
    
    import views.ui.PersonView;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.PersonVO;
    
    public class PersonMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "personMediator";
        
        private var _person:PersonVO;
        private var _personsProxy:PersonsProxy;
        private var _personnelDecor:PersonnelHelper;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            
            PersonTemplatesManager.getInstance();
        }
        
        public function set personId(value:String):void
        {
            if (_person && _person.personId == value)
                return;
            
            _person = personsProxy.getPersonById(value);
        }
        
        public function get personName():String
        {
            return _person ? _person.personName : Const.NO_TEXT;
        }
        
        public function get personAvatar():String
        {
            return _person ? _person.personImage : "";
        }
        
        public function get personBase():BaseVO
        {
            return _person ? personnelDecor.getEmployeePlace(_person.personId) : null;
        }
        
        public function get personProfession():String
        {
            if (_person)
            {
                var base:BaseVO = personnelDecor.getEmployeePlace(_person.personId);
                if (base)
                {
                    for each (var employee:EmployeeVO in base.basePersonnel.children)
                    {
                        if (employee.employeePersonId == _person.personId)
                            return employee.employeeProfessionId;
                    }
                }
            }
            return "";
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
        
        protected function get personnelDecor():PersonnelHelper
        {
            if (!_personnelDecor)
                _personnelDecor = new PersonnelHelper(null, personsProxy);
            return _personnelDecor;
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
            return [  ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                
            }
        }
    }
}