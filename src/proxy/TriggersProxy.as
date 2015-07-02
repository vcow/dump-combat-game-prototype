package proxy
{
    import helpers.PersonnelHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.TriggerVO;
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
        public function getTriggerValue(triggerId:uint, ...args):Number
        {
            for each (var trigger:TriggerVO in triggersVO.children)
            {
                if (trigger.triggerId == triggerId)
                    return trigger.triggerValue;
            }
            
            trigger = new TriggerVO();
            trigger.triggerId = triggerId;
            
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
        public function setTriggerValue(triggerId:uint, value:Number, type:String):Boolean
        {
            for each (var trigger:TriggerVO in triggersVO.children)
            {
                if (trigger.triggerId == triggerId)
                {
                    var newValue:Number = isNaN(trigger.triggerValue) ? 0 : trigger.triggerValue;
                    switch (type)
                    {
                        case SET: newValue = value; break;
                        case INC: newValue += value; break;
                        case DEC: newValue -= value; break;
                        default: return false;
                    }
                    
                    trigger.triggerValue = newValue;
                    return true;
                }
            }
            
            trigger = new TriggerVO();
            trigger.triggerId = triggerId;
            
            if (!trigger.triggerDesc)
                throw Error("Trying to set the value of undefined trigger (" + triggerId + ").");
            
            if (!trigger.triggerDesc.triggerIsComputable)
            {
                switch (type)
                {
                    case SET: 
                    case INC: trigger.triggerValue = value; break;
                    case DEC: trigger.triggerValue = -value; break;
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
        protected function calcTriggerValue(triggerId:uint, args:Array):Number
        {
            switch (triggerId)
            {
                case 1:     //< employeesCount
                    if (args.length == 0)
                    {
                        // Вернуть общее количество сотрудников
                        return (new PersonnelHelper()).getEmployees().length;
                    }
                    else
                    {
                        // Вернуть количество сотрудников указанной профессии
                        var professionId:uint = uint(args[0]);
                        if (professionId)
                            return (new PersonnelHelper()).getEmployees(professionId).length;
                    }
                    break;
                case 2:     //< resourcesCount
                    // Вернуть количество ресурсов указанного типа
                    var resourceId:uint = args.length > 0 ? uint(args[0]) : 0;
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