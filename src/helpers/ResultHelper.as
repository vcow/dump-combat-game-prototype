package helpers
{
    import dictionary.Const;
    
    import facade.ProtoFacade;
    
    import proxy.TriggersProxy;
    
    import vo.GiveBaseVO;
    import vo.IVO;
    import vo.PriceVO;
    import vo.ResourceVO;
    import vo.TriggerVO;
    import vo.VO;

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
         * @return выделенная цена, если таковая имеется в результате
         */
        public function applyResult(result:VO):Boolean
        {
            if (!result)
                return false;
            
            for each (var item:IVO in result.children)
            {
                switch (item.name)
                {
                    case TriggerVO.NAME:
                        var trigger:TriggerVO = TriggerVO(item);
                        _triggersProxy.setTriggerValue(trigger.triggerId, trigger.triggerValue, trigger.triggerValueType);
                        break;
                    case PriceVO.NAME:
                        ProtoFacade.getInstance().sendNotification(Const.CHANGE_RESOURCES, PriceVO(item));
                        break;
                    case ResourceVO.NAME:
                        var price:PriceVO = new PriceVO();
                        price.children.push(ResourceVO(item));
                        ProtoFacade.getInstance().sendNotification(Const.CHANGE_RESOURCES, price);
                        break;
                    case GiveBaseVO.NAME:
                        var giveBase:GiveBaseVO = GiveBaseVO(item);
                        if (giveBase.giveBaseAsRuin)
                            ProtoFacade.getInstance().sendNotification(Const.FOUND_RUINS, giveBase.giveBaseId);
                        else
                            ProtoFacade.getInstance().sendNotification(Const.CREATE_NEW_BASE, giveBase.giveBaseId);
                        break;
                    default:
                        throw Error("Result type " + item.name + " not supported.");
                }
            }
            return true;
        }
    }
}