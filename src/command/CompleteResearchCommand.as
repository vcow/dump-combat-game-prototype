package command
{
    import dictionary.Const;
    
    import helpers.ResultHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.InvestigationsProxy;
    
    import vo.ResearchVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на завершение исследования
     * 
     */
    
    public class CompleteResearchCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CompleteResearchCommand()
        {
            super();
        }
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var investigationsProxy:InvestigationsProxy = InvestigationsProxy(this.facade.retrieveProxy(InvestigationsProxy.NAME));
            var research:ResearchVO = investigationsProxy.getResearch(notification.getBody().toString());
            if (research && research.researchPercent >= 1.0)
            {
                for (var i:int = 0; i < investigationsProxy.armyVO.children.length; i++)
                {
                    if (investigationsProxy.armyVO.children[i] == research)
                    {
                        investigationsProxy.armyVO.children.splice(i, 1);
                        break;
                    }
                }
            }
            
            (new ResultHelper()).applyResult(research.researchDesc.researchResult);
            
            sendNotification(Const.RESEARCH_COMPLETED, research.researchId);
        }
    }
}