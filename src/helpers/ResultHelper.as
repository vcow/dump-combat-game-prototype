package helpers
{
    import facade.ProtoFacade;
    
    import proxy.TriggersProxy;
    
    import vo.IVO;
    import vo.PriceVO;
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
        private var _resourceHelper:ResourcesHelper;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ResultHelper(triggersProxy:TriggersProxy=null, resourceHelper:ResourcesHelper=null)
        {
            _triggersProxy = triggersProxy || TriggersProxy(ProtoFacade.getInstance().retrieveProxy(TriggersProxy.NAME));
            _resourceHelper = resourceHelper;
        }
        
        /**
         * Применить результат
         * @param result результат
         * @param extractPriceOnly извлечь и вернуть суммарную цену, указанную в обрабатываемом результате, если false, цена, в добавок, будет добавлена к ресурсам
         * @return выделенная цена, если таковая имеется в результате
         */
        public function applyResult(result:ResultVO, extractPriceOnly:Boolean=false):PriceVO
        {
            if (!result)
                return null;
            
            var res:PriceVO;
            for each (var item:IVO in result.children)
            {
                switch (item.name)
                {
                    case TriggerVO.NAME:
                        var trigger:TriggerVO = TriggerVO(item);
                        _triggersProxy.setTriggerValue(trigger.triggerId, trigger.triggerValue, trigger.triggerValueType);
                        break;
                    case PriceVO.NAME:
                        var price:PriceVO = PriceVO(item);
                        if (res)
                            res = resourceHelper.joinPrice(res, price);
                        else
                            res = price;
                        
                        if (!extractPriceOnly)
                            resourceHelper.pay(resourceHelper.invertPrice(price));
                        break;
                }
            }
            return res;
        }
        
        private function get resourceHelper():ResourcesHelper
        {
            if (!_resourceHelper)
                _resourceHelper = new ResourcesHelper();
            return _resourceHelper;
        }
    }
}