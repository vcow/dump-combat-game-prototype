package proxy
{
    import helpers.PersonnelHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.TriggerValueVO;
    import vo.TriggersVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси внутриигровых триггеров
     * 
     */
    
    public class TriggersProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "triggersProxy";
        
        public static const SET:String = "set";
        public static const INC:String = "inc";
        public static const DEC:String = "dec";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function TriggersProxy(data:TriggersVO=null)
        {
            super(NAME, data);
        }
        
        public function get triggersVO():TriggersVO
        {
            return getData() as TriggersVO;
        }
        
        /**
         * Получить значение триггера
         * @param triggerId идентификатор триггера
         * @param args список дополнительных аргументов (для вычислимых триггеров)
         * @return значение триггера
         */
        public function getTriggerValue(triggerId:String, ...args):Number
        {
            for each (var trigger:TriggerValueVO in triggersVO.children)
            {
                if (trigger.triggerValueTriggerId == triggerId)
                    return trigger.triggerValueValue;
            }
            
            trigger = new TriggerValueVO();
            trigger.triggerValueTriggerId = triggerId;
            
            if (!trigger.triggerDesc)
                throw Error("Requested the value of undefined trigger (" + triggerId + ").");
            
            if (trigger.triggerDesc.triggerIsComputable)
                return calcTriggerValue(triggerId, args);
            
            return NaN;
        }
        
        /**
         * Задать значение триггера
         * @param triggerId идентификатор задаваемого триггера
         * @param value новое значение
         * @param type тип операции (set - задать указанное значение, inc - прибавить указанное значение, dec - вычесть указанное значение)
         * @return true, если значение изменено
         */
        public function setTriggerValue(triggerId:String, value:Number, type:String):Boolean
        {
            for each (var trigger:TriggerValueVO in triggersVO.children)
            {
                if (trigger.triggerValueTriggerId == triggerId)
                {
                    var newValue:Number = isNaN(trigger.triggerValueValue) ? 0 : trigger.triggerValueValue;
                    switch (type)
                    {
                        case SET: newValue = value; break;
                        case INC: newValue += value; break;
                        case DEC: newValue -= value; break;
                        default: return false;
                    }
                    
                    trigger.triggerValueValue = newValue;
                    return true;
                }
            }
            
            trigger = new TriggerValueVO();
            trigger.triggerValueTriggerId = triggerId;
            
            if (!trigger.triggerDesc)
                throw Error("Trying to set the value of undefined trigger (" + triggerId + ").");
            
            if (!trigger.triggerDesc.triggerIsComputable)
            {
                switch (type)
                {
                    case SET: 
                    case INC: trigger.triggerValueValue = value; break;
                    case DEC: trigger.triggerValueValue = -value; break;
                    default: return false;
                }
                
                triggersVO.children.push(trigger);
                return true;
            }
            
            return false;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Вспомогательная функция расчета значения вычислимого триггера
         * @param triggerId идентификатор триггера
         * @param args дополнительные аргументы
         * @return расчетное значение триггера
         */
        protected function calcTriggerValue(triggerId:String, args:Array):Number
        {
            switch (triggerId)
            {
                case "employeesCount":
                    if (args.length == 0)
                    {
                        // Вернуть общее количество сотрудников
                        return (new PersonnelHelper()).getEmployees().length;
                    }
                    else
                    {
                        // Вернуть количество сотрудников указанной профессии
                        var professionId:String = args[0].toString();
                        if (professionId)
                            return (new PersonnelHelper()).getEmployees(professionId).length;
                    }
                    break;
                case "resourcesCount":
                    // Вернуть количество ресурсов указанного типа
                    var resourceId:String = args.length > 0 ? args[0].toString() : "";
                    if (resourceId)
                        return (new ResourcesHelper()).getResource(resourceId);
                    break;
                default:
                    throw Error("Has no algorithm to calculate required trigger (" + triggerId + ").");
            }
            
            return NaN;
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:TriggersVO = appDataProxy.getChildByName(TriggersVO.NAME) as TriggersVO;
                
                if (!value)
                    value = new TriggersVO();
                
                setData(value);
                
                appDataProxy.updateChild(triggersVO);
            }
            
            return data;
        }
    }
}