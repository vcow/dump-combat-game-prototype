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
        public static const RANDOM:String = "random";
        
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
         * @param condition условие (если null, всегда считается выполненным, если {} - всегда невыполненным)
         * @return true, если условие выполняется
         */
        public function parseCondition(condition:Object):Boolean
        {
            if (!condition)
                return true;
            
            for (var key:String in condition)
            {
                var res:Boolean;
                var data:Object = condition[key];
                var op:String = key.replace(/(\D*).*/, "$1");
                
                switch (op)
                {
                    case IF:
                        try {
                            res = false;
                            var args:Array = [ data.trigger ];
                            if (data.hasOwnProperty("value"))
                                args = args.concat(parseValue(data.value));
                            var value:Number = _triggersProxy.getTriggerValue.apply(this, args);
                            if (isNaN(value))
                                break;
                            
                            var min:Number = data.hasOwnProperty("min") ? Number(data.min) : NaN;
                            if (!isNaN(min))
                            {
                                if (value < min)
                                    break;
                            }
                            
                            var max:Number = data.hasOwnProperty("max") ? Number(data.max) : NaN;
                            if (!isNaN(max))
                            {
                                if (value > max)
                                    break;
                            }
                            
                            if (isNaN(min) && isNaN(max))
                                res = value != 0;
                            else
                                res = true;
                        }
                        catch (e:Error) {
                        }
                        break;
                    case OR:
                        res = false;
                        for (key in data)
                        {
                            var sub:Object = {};
                            sub[key] = data[key];
                            res ||= parseCondition(sub);
                            
                            if (res)
                                break;
                        }
                        break;
                    case AND:
                        res = true;
                        for (key in data)
                        {
                            sub = {};
                            sub[key] = data[key];
                            res &&= parseCondition(sub);
                            
                            if (!res)
                                break;
                        }
                        break;
                    case NOT:
                        res = !parseCondition(data);
                        break;
                    case RANDOM:
                        var chance:Number = Number(data);
                        res = isNaN(chance) ? false : chance >= 1.0 || Math.random() <= chance;
                        break;
                    default:
                        throw Error("Usupported condition tag (" + op + ").");
                }
                
                return res;
            }
            
            return false;
        }
        
        /**
         * Парсинг дополнительных аргументов для получения значения триггера (допускает более одного аргумента)
         * @param raw значение или набор значений аргументов
         * @return массив, содержащий набор значений аргументов
         */
        private function parseValue(raw:Object):Array
        {
            var sub:Array = [];
            for (var key:String in raw)
                sub.push({ key: key, value: raw[key] });
            
            var res:Array = [];
            if (sub.length == 0)
            {
                res.push(raw);
            }
            else
            {
                sub.sortOn("key");
                for (var i:int = 0; i < sub.length; i++)
                    res.push(sub[i].value);
            }
            
            return res;
        }
    }
}