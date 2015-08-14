package command
{
    import command.data.UpdateResearchCmdData;
    
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
                    
                }
                else
                {
                    // Создается новое исследование
                    research = new ResearchVO();
                    research.researchId = data.researchId;
                    research.researchPercent = 0;
                    
                    if (!research.researchDesc)
                        throw Error("Trying to start unexisting investigation (" + data.researchId + ").");
                    
                    investigationsProxy.investigationsVO.children.push(research);
                    
                    var freeScientists:Vector.<PersonVO> = (new InvestigationsHelper(investigationsProxy)).getFreeScientists();
                    var freeLabSpace:int = (new ModulesHelper()).getSpace(ModuleDescVO.LAB);
                    var numScientists:int = Math.min(freeScientists.length, freeLabSpace, data.numScientists);
                    
                    for (var i:int = 0; i < numScientists; i++)
                    {
                        var worker:WorkerVO = new WorkerVO();
                        worker.workerPersonId = freeScientists[i].personId;
                        
                        research.children.push(worker);
                    }
                }
            }
        }
    }
}