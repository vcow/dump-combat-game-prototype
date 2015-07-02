package helpers
{
    import facade.ProtoFacade;
    
    import proxy.TriggersProxy;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор условий
     * 
     */
    
    public class ConditionHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _triggersProxy:TriggersProxy;
        
        public static const IF:String = "if";
        public static const OR:String = "or";
        public static const AND:String = "and";
        public static const NOT:String = "not";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ConditionHelper(triggersProxy:TriggersProxy=null)
        {
            _triggersProxy = triggersProxy || TriggersProxy(ProtoFacade.getInstance().retrieveProxy(TriggersProxy.NAME));
        }
        
        /**
         * Получить результат для заданного условия. Условие передается в виде объекта,
         * содержащего поля с именами if#, or# and# not# и значениями trigger, value, min, max.
         * @param condition условие
         * @return true, если условие выполняется
         */
        public function parseCondition(condition:Object):Boolean
        {
            if (!condition)
                return true;
            
            for (var key:String in condition)
            {
                var op:String = key.replace(/(\D*).*/, "$1");
                switch (op)
                {
                    case IF:
                        break;
                    case OR:
                        break;
                    case AND:
                        break;
                    case NOT:
                        break;
                    default:
                        throw Error("Usupported condition tag (" + op + ").");
                }
            }
            
            return false;
        }
    }
}