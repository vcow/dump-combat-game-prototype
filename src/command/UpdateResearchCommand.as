package command
{
    import command.data.UpdateResearchCmdData;
    
    import dictionary.Const;
    
    import helpers.ConditionHelper;
    import helpers.InvestigationsHelper;
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.InvestigationsProxy;
    
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.ResearchVO;
    import vo.WorkerVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Запрос на изменение параметров текущего исследования
     * 
     */
    
    public class UpdateResearchCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function UpdateResearchCommand()
        {
            super();
        }
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:UpdateResearchCmdData = notification.getBody() as UpdateResearchCmdData;
            
            if (data)
            {
                var investigationsProxy:InvestigationsProxy = InvestigationsProxy(this.facade.retrieveProxy(InvestigationsProxy.NAME));
                var research:ResearchVO = investigationsProxy.getResearch(data.researchId);
                if (research)
                {
                    // Модифицируется существующее исследование
                    if (research.children.length > data.numScientists)
                    {
                        // Ученые снимаются с исследования
                        var numScientists:int = data.numScientists < 0 ? 0 : data.numScientists;
                        research.children.splice(0, research.children.length - numScientists);
                        
                        sendNotification(Const.RESEARCH_UPDATED, research.researchId);
                    }
                    else if (research.children.length < data.numScientists)
                    {
                        // Ученые назначаются на исследование
                        var freeScientists:Vector.<PersonVO> = (new InvestigationsHelper(investigationsProxy)).getFreeScientists();
                        var freeLabSpace:int = (new ModulesHelper()).getSpace(ModuleDescVO.LAB);
                        numScientists = Math.min(freeScientists.length, freeLabSpace, data.numScientists - research.children.length);
                        
                        for (var i:int = 0; i < numScientists; i++)
                        {
                            var worker:WorkerVO = new WorkerVO();
                            worker.workerPersonId = freeScientists[i].personId;
                            
                            research.children.push(worker);
                        }
                        
                        sendNotification(Const.RESEARCH_UPDATED, research.researchId);
                    }
                }
                else
                {
                    // Создается новое исследование
                    research = new ResearchVO();
                    research.researchId = data.researchId;
                    research.researchPercent = 0;
                    
                    if (!research.researchDesc)
                        throw Error("Trying to start unexisting investigation (" + data.researchId + ").");
                    
                    var conditionDecor:ConditionHelper = new ConditionHelper();
                    if (!conditionDecor.parseCondition(research.researchDesc.researchCondition) ||
                        conditionDecor.parseCondition(research.researchDesc.researchCompleteCondition))
                    {
                        // Исследование не может быть начато, или уже завершено
                        return;
                    }
                    
                    investigationsProxy.investigationsVO.children.push(research);
                    
                    freeScientists = (new InvestigationsHelper(investigationsProxy)).getFreeScientists();
                    freeLabSpace = (new ModulesHelper()).getSpace(ModuleDescVO.LAB);
                    numScientists = Math.min(freeScientists.length, freeLabSpace, data.numScientists);
                    
                    for (i = 0; i < numScientists; i++)
                    {
                        worker = new WorkerVO();
                        worker.workerPersonId = freeScientists[i].personId;
                        
                        research.children.push(worker);
                    }
                    
                    sendNotification(Const.RESEARCH_STARTED, research.researchId);
                }
            }
        }
    }
}