package dictionary
{
    import vo.TriggerDescVO;

    /**
     * 
     * @author y.vircowskiy
     * Библиотека триггеров
     * 
     */
    
    public class TriggersDict
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        [Embed(source="data/triggers.xml", mimeType="application/octet-stream")]
        private static const source:Class;
        
        private static var _instance:TriggersDict;
        private static var _triggers:Vector.<TriggerDescVO>;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function TriggersDict()
        {
            if (_instance != null)
                throw Error("TriggersDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
        
        public static function getInstance():TriggersDict
        {
            if (!_instance)
                _instance = new TriggersDict();
            return _instance;
        }
        
        public function get triggers():Vector.<TriggerDescVO>
        {
            if (!_triggers)
            {
                _triggers = new Vector.<TriggerDescVO>();
                
                var src:XML = XML(new source());
                var items:XMLList = src.child(TriggerDescVO.NAME);
                for each (var item:XML in items)
                {
                    var trigger:TriggerDescVO = new TriggerDescVO();
                    trigger.deserialize(item);
                    _triggers.push(trigger);
                }
            }
            return _triggers;
        }
        
        /**
         * Получить описание триггера по его идентификатору
         * @param triggerId идентификатор триггера
         * @return описание
         */
        public function getTrigger(triggerId:String):TriggerDescVO
        {
            for each (var trigger:TriggerDescVO in triggers)
            {
                if (trigger.triggerId == triggerId)
                    return trigger;
            }
            return null;
        }
    }
}