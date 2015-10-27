package helpers
{
    import flash.display.DisplayObjectContainer;
    
    import mx.core.FlexGlobals;
    import mx.managers.PopUpManager;
    import mx.resources.ResourceManager;
    
    import spark.events.PopUpEvent;
    
    import command.data.AttackBaseCmdData;
    
    import dictionary.Const;
    
    import facade.ProtoFacade;
    
    import proxy.TriggersProxy;
    
    import views.modal.AlertPopUp;
    
    import vo.AttackBaseVO;
    import vo.AttackerVO;
    import vo.EventVO;
    import vo.FindBaseVO;
    import vo.GiveBaseVO;
    import vo.GiveQuestVO;
    import vo.IVO;
    import vo.PriceVO;
    import vo.ResourceVO;
    import vo.ResultVO;
    import vo.TimeoutVO;
    import vo.TriggerVO;
    import vo.UiMessageVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор для обработки результата
     * 
     */
    
    public class ResultHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _triggersProxy:TriggersProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ResultHelper(triggersProxy:TriggersProxy=null)
        {
            _triggersProxy = triggersProxy || TriggersProxy(ProtoFacade.getInstance().retrieveProxy(TriggersProxy.NAME));
        }
        
        /**
         * Применить результат
         * @param result результат
         * @return true, если результат выполнен
         */
        public function applyResult(result:ResultVO):Boolean
        {
            if (!result)
                return false;
            
            for each (var item:IVO in result.children)
            {
                switch (item.name)
                {
                    case TriggerVO.NAME:        //< Задать значение триггера
                        var trigger:TriggerVO = TriggerVO(item);
                        _triggersProxy.setTriggerValue(trigger.triggerId, trigger.triggerValue, trigger.triggerValueType);
                        break;
                    case PriceVO.NAME:          //< Добавить ресурсы, переданные в виде цены
                        ProtoFacade.getInstance().sendNotification(Const.CHANGE_RESOURCES, PriceVO(item));
                        break;
                    case ResourceVO.NAME:       //< Добавить ресурс
                        var price:PriceVO = new PriceVO();
                        price.children.push(ResourceVO(item));
                        ProtoFacade.getInstance().sendNotification(Const.CHANGE_RESOURCES, price);
                        break;
                    case GiveBaseVO.NAME:       //< Выдать юзеру базу
                        var giveBase:GiveBaseVO = GiveBaseVO(item);
                        if (giveBase.giveBaseAsRuin)
                            ProtoFacade.getInstance().sendNotification(Const.FOUND_RUINS, giveBase.giveBaseId);
                        else
                            ProtoFacade.getInstance().sendNotification(Const.CREATE_NEW_BASE, giveBase.giveBaseId);
                        break;
                    case FindBaseVO.NAME:       //< Найти новую вражескую базу
                        var findBase:FindBaseVO = FindBaseVO(item);
                        ProtoFacade.getInstance().sendNotification(Const.FIND_TARGET, findBase.findBaseId);
                        break;
                    case AttackBaseVO.NAME:     //< Атаковать базу
                        var attackBase:AttackBaseVO = AttackBaseVO(item);
                        var army:Vector.<String> = new Vector.<String>();
                        for each (var attacker:AttackerVO in attackBase.children)
                            army.push(attacker.attackerId);
                        ProtoFacade.getInstance().sendNotification(Const.ATTACK_BASE, new AttackBaseCmdData(
                            attackBase.attackBaseTarget, attackBase.attackBaseDeparture, army));
                        break;
                    case UiMessageVO.NAME:      //< Выдать сообщение для юзера
                        var uiMessage:UiMessageVO = UiMessageVO(item);
                        var alertPopUp:AlertPopUp = new AlertPopUp();
                        alertPopUp.text = uiMessage.uiMessageText;
                        alertPopUp.buttonFlags = uiMessage.uiMessageButtons;
                        
                        alertPopUp.addEventListener(PopUpEvent.CLOSE, function(event:PopUpEvent):void {
                            if (event.data == Const.OK && uiMessage.uiMessageOkHandler)
                                applyResult(uiMessage.uiMessageOkHandler.okResult);
                            else if (event.data == Const.CANCEL && uiMessage.uiMessageCancelHandler)
                                applyResult(uiMessage.uiMessageCancelHandler.cancelResult);
                            else if (event.data == Const.YES && uiMessage.uiMessageYesHandler)
                                applyResult(uiMessage.uiMessageYesHandler.yesResult);
                            else if (event.data == Const.NO && uiMessage.uiMessageNoHandler)
                                applyResult(uiMessage.uiMessageNoHandler.noResult);
                        });
                        
                        alertPopUp.open(DisplayObjectContainer(FlexGlobals.topLevelApplication), true);
                        PopUpManager.centerPopUp(alertPopUp);
                        break;
                    case GiveQuestVO.NAME:      //< Выдать квест (не обрабатывается здесь из за рекурсивных вызовов из CheckQuestsCommand)
                    case TimeoutVO.NAME:        //< Запуск таймаута (не обрабатывается здесь из за привязки к квесту, см. CheckQuestsCommand)
                    case EventVO.NAME:          //< Отправка события (не обрабатывается здесь из за дополнительных параметров, см. TimersProxy)
                        return false;
                    default:
                        throw Error("Result type " + item.name + " not supported.");
                }
            }
            return true;
        }
    }
}