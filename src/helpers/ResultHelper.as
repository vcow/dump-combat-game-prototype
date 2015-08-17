package helpers
{
    import facade.ProtoFacade;
    
    import proxy.TriggersProxy;
    
    import vo.IVO;
    import vo.ResultVO;
    import vo.TriggerVO;

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
         * @return true, если результат применен успешно
         */
        public function applyResult(result:ResultVO):Boolean
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
                }
            }
            return true;
        }
    }
}