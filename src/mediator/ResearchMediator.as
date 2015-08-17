package mediator
{
    import command.data.UpdateResearchCmdData;
    
    import dictionary.Const;
    
    import events.ResearchEvent;
    
    import helpers.InvestigationsHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.InvestigationsProxy;
    
    import views.ui.ResearchView;
    
    public class ResearchMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "researchMediator";
        
        private var _investigationsProxy:InvestigationsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ResearchMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Получить количество ученых, задействованных в указанном исследовании
         * @param researchId идентификатор исследования
         * @return количество задействованных ученых
         */
        public function getEmployedScientists(researchId:String):int
        {
            return investigationsProxy.getEmployedScientists(researchId).children.length;
        }
        
        /**
         * Получить количество незадействованных ученых
         * @return количество незадействованных ученых
         */
        public function getFreeScientists():int
        {
            return (new InvestigationsHelper(investigationsProxy)).getFreeScientists().length;
        }
        
        protected function get researchView():ResearchView
        {
            return viewComponent as ResearchView;
        }
        
        protected function get investigationsProxy():InvestigationsProxy
        {
            if (!_investigationsProxy)
                _investigationsProxy = this.facade.retrieveProxy(InvestigationsProxy.NAME) as InvestigationsProxy;
            return _investigationsProxy;
        }
        
        /**
         * Освободить текущий визуальный компонент
         */
        private function releaseViewComponent():void
        {
            if (!researchView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            researchView.removeEventListener(ResearchEvent.CHANGE_RESEARCH_SCIENTISTS_COUNT, changeResearchScientistsCountHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!researchView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            researchView.addEventListener(ResearchEvent.CHANGE_RESEARCH_SCIENTISTS_COUNT, changeResearchScientistsCountHandler);
            
            if (investigationsProxy.getResearch(researchView.researchId))
            {
                // Исследование в списке активных, оно не завершено
                researchView.currentState = "unexplored";
            }
            else
            {
                // Исследование не числится в списке активных, предположительно, оно уже завершено
                researchView.currentState = "complete";
            }
            
            // /TODO
        }
        
        private function changeResearchScientistsCountHandler(event:ResearchEvent):void
        {
            sendNotification(Const.UPDATE_RESEARCH, new UpdateResearchCmdData(event.researchId, event.numScientists));
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
            return [ Const.RESEARCH_COMPLETE ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.RESEARCH_COMPLETE:
                    if (researchView)
                    {
                        var researchId:String = notification.getBody().toString();
                        if (researchId == researchView.researchId)
                            researchView.currentState = "complete";
                        else
                            researchView.freeScientists = getFreeScientists();
                    }
                    break;
            }
        }
    }
}