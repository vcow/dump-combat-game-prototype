package proxy
{
    import dictionary.Const;
    import dictionary.TriggersDict;
    
    import helpers.ArmyHelper;
    import helpers.PersonnelHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.BaseVO;
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
        public static const TARGETS_COUNT_TRIGGER:String = "targetsCount";
        public static const UNITS_COUNT_TRIGGER:String = "unitsCount";
        public static const MODULES_COUNT_TRIGGER:String = "modulesCount";
        
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
            
            if (trigger.triggerDesc)
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
                        sendNotification(Const.TRIGGER_CHANGED, trigger.triggerValueTriggerId);
                    }
                    return true;
                }
            }
            
            trigger = new TriggerValueVO();
            trigger.triggerValueTriggerId = triggerId;
            
            if (!trigger.triggerDesc)
            {
                switch (type)
                {
                    case SET: 
                    case INC: trigger.triggerValueValue = value; break;
                    case DEC: trigger.triggerValueValue = -value; break;
                    default: return false;
                }
                
                triggersVO.children.push(trigger);
                sendNotification(Const.TRIGGER_CHANGED, trigger.triggerValueTriggerId);
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
            if (TriggersDict.getInstance().getTrigger(triggerId))
                sendNotification(Const.TRIGGER_CHANGED, triggerId);
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
                    var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                    if (args.length == 0)
                    {
                        // Вернуть общее количество сотрудников
                        return (new PersonnelHelper(basesListProxy)).getEmployees().length;
                    }
                    else if (args.length == 1)
                    {
                        // Вернуть количество сотрудников указанной профессии для всех баз, или количество сотрудников для указанной базы
                        if (basesListProxy.getBase(args[0].toString()))
                            return (new PersonnelHelper(basesListProxy)).getEmployees(null, args[0].toString()).length;
                        else
                            return (new PersonnelHelper(basesListProxy)).getEmployees(args[0].toString()).length;
                    }
                    else if (args.length == 2)
                    {
                        // Вернуть количество сотрудников указанной профессии для указанной базы
                        if (basesListProxy.getBase(args[0].toString()))
                            return (new PersonnelHelper(basesListProxy)).getEmployees(args[1].toString(), args[0].toString()).length;
                        else
                            return (new PersonnelHelper(basesListProxy)).getEmployees(args[0].toString(), args[1].toString()).length;
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
                case TARGETS_COUNT_TRIGGER:
                    // Вернуть количество известных вражеских баз игрока
                    return BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getTargetsList().length;
                case UNITS_COUNT_TRIGGER:
                    if (args.length == 0)
                    {
                        // Вернуть общее количество юнитов
                        return (new ArmyHelper()).getUnitsOnBase().length;
                    }
                    else
                    {
                        // Вернуть количество боевых юнитов на указанной базе
                        var baseId:String = args[0].toString();
                        return (new ArmyHelper()).getUnitsOnBase(baseId).length;
                    }
                    break;
                case MODULES_COUNT_TRIGGER:
                    basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                    var res:Number;
                    
                    if (args.length == 0)
                    {
                        // Количество всех модулей для всех баз
                        res = 0;
                        for each (var base:BaseVO in basesListProxy.getBasesList())
                            res += base.baseModules.children.length;
                    }
                    else if (args.length == 1)
                    {
                        // Количество всех модулей для указанной базы, или модулей указанного типа для всех баз
                        base = basesListProxy.getBase(args[0].toString()) as BaseVO;
                        if (base)
                            return base.baseModules.children.length;
                        
                        res = 0;
                        var moduleId:String = args[0].toString();
                        for each (base in basesListProxy.getBasesList())
                            res += base.getModules(moduleId, true).length;
                    }
                    else if (args.length == 2)
                    {
                        // Количество модулей указанного типа для указанной базы
                        base = basesListProxy.getBase(args[0].toString()) as BaseVO;
                        if (base)
                        {
                            moduleId = args[1].toString();
                        }
                        else
                        {
                            moduleId = args[0].toString();
                            base = basesListProxy.getBase(args[1].toString()) as BaseVO;
                        }
                        
                        if (base)
                            return base.getModules(moduleId, true).length;
                    }
                    
                    return res;
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