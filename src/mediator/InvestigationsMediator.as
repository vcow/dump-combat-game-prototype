package mediator
{
    import mx.collections.ArrayCollection;
    
    import dictionary.InvestigationsDict;
    
    import helpers.ConditionHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.InvestigationsProxy;
    
    import views.InvestigationsView;
    
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
            for each (var research:ResearchVO in investigationsProxy.investigationsVO.children)
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
        
        protected function get investigationsView():InvestigationsView
        {
            return viewComponent as InvestigationsView;
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