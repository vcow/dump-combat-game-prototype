package command
{
    import dictionary.Const;
    
    import helpers.ConditionHelper;
    import helpers.ResultHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.QuestsProxy;
    import proxy.TriggersProxy;
    
    import vo.GiveQuestVO;
    import vo.IVO;
    import vo.QuestVO;
    import vo.QuestsVO;
    import vo.ResultVO;
    import vo.StepTargetVO;
    import vo.StepTargetsVO;
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
        private var _resultDecor:ResultHelper;
        
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
        
        private function get resultDecor():ResultHelper
        {
            if (!_resultDecor)
                _resultDecor = new ResultHelper(triggersProxy);
            return _resultDecor;
        }
        
        private function processQuests(quests:Vector.<IVO>):void
        {
            _checkInProcess = true;
            
            do {
                var checkAgain:Boolean = false;     // Цикл перепроверки на случай выполнения нескольких шагов подряд
                
                for (var i:int = quests.length - 1; i >= 0; i--)
                {
                    var quest:QuestVO = QuestVO(quests[i]);
                    
                    if (quest.children.length > 0)
                    {
                        // Есть дочерние квесты. Текущий квест не продолжится до их завершения
                        _checkInProcess = false;
                        
                        processQuests(quest.children);
                        
                        _checkInProcess = true;
                        
                        if (quest.children.length > 0)
                            continue;               // Еще остались незакрытые дочерние квесты
                    }
                    
                    var applyNextStep:Boolean = false;
                    if (quest.questStep > 0)
                    {
                        var currentStep:StepVO = StepVO(quest.questDecs.children[quest.questStep - 1]);
                        var targets:StepTargetsVO = currentStep.stepTargets;
                        if (targets && targets.children.length > 0)
                        {
                            var conditionDecor:ConditionHelper = new ConditionHelper(triggersProxy);
                            for each (var stepTarget:StepTargetVO in targets.children)
                            {
                                applyNextStep = conditionDecor.parseCondition(stepTarget.stepTargetCondition);
                                if (applyNextStep)
                                {
                                    // Выполнилось условие этой цели, выдать соответствующую награду
                                    applyResult(stepTarget.stepTargetResult, quest);
                                    break;
                                }
                            }
                        }
                        else
                        {
                            applyNextStep = true;
                        }
                    }
                    else
                    {
                        applyNextStep = true;
                    }
                    
                    if (applyNextStep)
                    {
                        // Завершился текущий шаг, или стартовал новый квест
                        
                        checkAgain = true;
                        quest.questStep++;
                        
                        if (quest.questStep > quest.questDecs.children.length)
                        {
                            // Квест завершен
                            quests.splice(i, 1);
                            sendNotification(Const.QUEST_FINISHED, quest.questId);
                            continue;
                        }
                        
                        currentStep = StepVO(quest.questDecs.children[quest.questStep - 1]);
                        applyResult(currentStep.stepResult, quest);         // Выдать награду нового шага
                    }
                }
            } while (checkAgain);
            
            _checkInProcess = false;
        }
        
        private function applyResult(result:ResultVO, parent:QuestVO):void
        {
            if (!resultDecor.applyResult(result))
            {
                for each (var item:IVO in result.children)
                {
                    switch (item.name)
                    {
                        case GiveQuestVO.NAME:      //< Выдать квест
                            var giveQuest:GiveQuestVO = GiveQuestVO(item);
                            var quest:QuestVO = QuestsProxy(this.facade.retrieveProxy(QuestsProxy.NAME)).startQuest(
                                giveQuest.giveQuestId, giveQuest.giveQuestAsSubquest ? parent : null);
                            
                            _checkInProcess = false;
                            processQuests(giveQuest.giveQuestAsSubquest ? quest.children : new <IVO>[ quest ]);
                            _checkInProcess = true;
                            break;
                    }
                }
            }
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            if (_checkInProcess)
                return;
            
            var quests:QuestsVO = QuestsProxy(this.facade.retrieveProxy(QuestsProxy.NAME)).questsVO;
            processQuests(quests.children);
        }
    }
}