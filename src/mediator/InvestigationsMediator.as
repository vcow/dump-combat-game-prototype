package mediator
{
    import mx.collections.ArrayCollection;
    
    import command.data.UpdateResearchCmdData;
    
    import dictionary.Const;
    import dictionary.InvestigationsDict;
    
    import events.ResearchEvent;
    
    import helpers.ConditionHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.InvestigationsProxy;
    
    import views.protoInvestigationsView;
    
    import vo.ResearchDescVO;
    import vo.ResearchVO;
    
    public class InvestigationsMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "investigationsMediator";
        
        private var _investigationsProxy:InvestigationsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function InvestigationsMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
            applyViewComponent();
        }
        
        /**
         * Получить список завершенных исследований
         * @return список завершенных исследований
         */
        public function getCompletedResearch():ArrayCollection
        {
            var res:Array = [];
            var investigations:Vector.<ResearchDescVO> = InvestigationsDict.getInstance().getInvestigations(true);
            for each (var researchDesc:ResearchDescVO in investigations)
            {
                res.push({
                    id: researchDesc.researchId,
                    label: researchDesc.researchResultTitle,
                    requirements: researchDesc.researchRequirements,
                    description: researchDesc.researchResultDescription,
                    complete: true,
                    inProcess: false,
                    available: true
                });
            }
            return new ArrayCollection(res);
        }
        
        /**
         * Получить список незавершенных, текущих исследований
         * @return список текущих исследований
         */
        public function getUnfinishedResearch():ArrayCollection
        {
            var res:Array = [];
            var investigationsDict:InvestigationsDict = InvestigationsDict.getInstance();
            for each (var research:ResearchVO in investigationsProxy.armyVO.children)
            {
                var researchDesc:ResearchDescVO = investigationsDict.getResearch(research.researchId);
                res.push({
                    id: researchDesc.researchId,
                    label: researchDesc.researchTitle,
                    requirements: researchDesc.researchRequirements,
                    description: "",
                    complete: false,
                    inProcess: true,
                    available: true
                });
            }
            return new ArrayCollection(res);
        }
        
        /**
         * Получить список всех исследований
         * @return список всех исследований
         */
        public function getAllResearch():ArrayCollection
        {
            var res:ArrayCollection = getCompletedResearch();
            res.addAll(getUnfinishedResearch());
            return res;
        }
        
        /**
         * Получить список доступных новых исследований
         * @return список доступных исследований
         */
        public function getAvailableResearch():ArrayCollection
        {
            var res:Array = [];
            var investigations:Vector.<ResearchDescVO> = InvestigationsDict.getInstance().getInvestigations(false, false, false);
            var conditionDecor:ConditionHelper = new ConditionHelper();
            
            for each (var researchDesc:ResearchDescVO in investigations)
            {
                if (investigationsProxy.getResearch(researchDesc.researchId))
                    continue;
                
                res.push({
                    id: researchDesc.researchId,
                    label: researchDesc.researchTitle,
                    requirements: researchDesc.researchRequirements,
                    description: "",
                    complete: false,
                    inProcess: false,
                    available: conditionDecor.parseCondition(researchDesc.researchCondition)
                });
            }
            return new ArrayCollection(res);
        }
        
        protected function get investigationsView():protoInvestigationsView
        {
            return viewComponent as protoInvestigationsView;
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
            if (!investigationsView)
                return;
            
            // TODO: Удалить все обработчики событий, если таковые были установлены
            
            investigationsView.removeEventListener(ResearchEvent.BEGIN_RESEARCH, beginResearchHandler);
            
            // /TODO
        }
        
        /**
         * Инициализировать текущий визуальный компонент
         */
        private function applyViewComponent():void
        {
            if (!investigationsView)
                return;
            
            // TODO: Проинициализировать поля компонента актуальными значениями, устновить оброботчики событий, если нужно
            
            investigationsView.addEventListener(ResearchEvent.BEGIN_RESEARCH, beginResearchHandler);
            
            // /TODO
        }
        
        /**
         * Пришла команда на начало нового исследования
         * @param event событие
         */
        private function beginResearchHandler(event:ResearchEvent):void
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
            return [ Const.RESEARCH_UPDATED, Const.RESEARCH_STARTED, Const.RESEARCH_COMPLETED ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch (notification.getName())
            {
                case Const.RESEARCH_UPDATED:
                case Const.RESEARCH_STARTED:
                case Const.RESEARCH_COMPLETED:
                    if (investigationsView)
                        investigationsView.updateList();
                    break;
            }
        }
    }
}