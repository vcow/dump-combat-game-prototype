package command
{
    import dictionary.Const;
    
    import helpers.ConditionHelper;
    import helpers.ResultHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.QuestsProxy;
    import proxy.TriggersProxy;
    
    import vo.QuestVO;
    import vo.QuestsVO;
    import vo.StepVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Проверка теккущего состояния квестов, отработка шагов по их завершении
     * 
     */
    
    public class CheckQuestsCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private static var _checkInProcess:Boolean;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _triggersProxy:TriggersProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CheckQuestsCommand()
        {
            super();
        }
        
        private function get triggersProxy():TriggersProxy
        {
            if (!_triggersProxy)
                _triggersProxy = TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME));
            return _triggersProxy;
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            if (_checkInProcess)
                return;
            
            _checkInProcess = true;
            
            var quests:QuestsVO = QuestsProxy(this.facade.retrieveProxy(QuestsProxy.NAME)).questsVO;
            
            do {
                var checkAgain:Boolean = false;     // Цикл перепроверки на случай выполнения нескольких шагов подряд
                
                for (var i:int = quests.children.length - 1; i >= 0; i--)
                {
                    var quest:QuestVO = QuestVO(quests.children[i]);
                    
                    var applyNextStep:Boolean;
                    if (quest.questStep > 0)
                    {
                        var currentStep:StepVO = StepVO(quest.questDecs.children[quest.questStep - 1]);
                        applyNextStep = (new ConditionHelper(triggersProxy)).parseCondition(currentStep.stepCondition);
                    }
                    else
                    {
                        applyNextStep = true;
                    }
                    
                    if (applyNextStep)
                    {
                        // Завершился текущий шаг, или стартовал новый квест
                        
                        checkAgain = true;
                        
                        var resultDecor:ResultHelper = new ResultHelper(triggersProxy);
                        
                        if (currentStep)
                            resultDecor.applyResult(currentStep.stepResult);        // Выдать результат предыдущего шага
                        
                        quest.questStep++;
                        
                        if (quest.questStep > quest.questDecs.children.length)
                        {
                            // Квест завершен
                            quests.children.splice(i, 1);
                            sendNotification(Const.QUEST_FINISHED, quest.questId);
                            continue;
                        }
                        
                        currentStep = StepVO(quest.questDecs.children[quest.questStep - 1]);
                        resultDecor.applyResult(currentStep.stepReward);            // Выдать награду нового шага
                    }
                }
            } while (checkAgain);
            
            _checkInProcess = false;
        }
    }
}