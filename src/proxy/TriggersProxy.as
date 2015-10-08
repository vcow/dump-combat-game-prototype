package proxy
{
    import dictionary.Const;
    import dictionary.TriggersDict;
    
    import helpers.PersonnelHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.TriggerDescVO;
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
        
        public static const EMPLOYEES_COUNT_TRIGGER:String = "employeesCount";
        public static const RESOURCES_COUNT_TRIGGER:String = "resourcesCount";
        public static const BASES_COUNT_TRIGGER:String = "basesCount";
        
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
                    
                    if (trigger.triggerValueValue != newValue)
                    {
                        trigger.triggerValueValue = newValue;
                        sendNotification(Const.TRIGGER_CHANGED, trigger.triggerDesc);
                    }
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
                sendNotification(Const.TRIGGER_CHANGED, trigger.triggerDesc);
                return true;
            }
            
            return false;
        }
        
        /**
         * Произошло изменение значения, влекущее изменение триггера
         * @param triggerId идентификатор изменившегося
         */
        public function valueChanged(triggerId:String):void
        {
            var triggerDesc:TriggerDescVO = TriggersDict.getInstance().getTrigger(triggerId);
            if (triggerDesc && triggerDesc.triggerIsComputable)
                sendNotification(Const.TRIGGER_CHANGED, triggerDesc);
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
                case EMPLOYEES_COUNT_TRIGGER:
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
                case RESOURCES_COUNT_TRIGGER:
                    // Вернуть количество ресурсов указанного типа
                    var resourceId:String = args.length > 0 ? args[0].toString() : "";
                    if (resourceId)
                        return (new ResourcesHelper()).getResource(resourceId);
                    break;
                case BASES_COUNT_TRIGGER:
                    // Вернуть количество баз игрока
                    return BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBasesList().length;
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