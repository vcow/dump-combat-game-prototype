package vo
{
    import proxy.TriggersProxy;

    /**
     * 
     * @author y.vircowskiy
     * Value Object значения триггера в результате
     * 
     */
    
    public class TriggerVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "trigger";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var triggerId:String;                        //< Идентификатор триггера
        public var triggerValue:Number;                     //< Новое значение триггера
        public var triggerValueType:String;                 //< Тип модификации триггера (set, inc, dec)
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function TriggerVO()
        {
            super(NAME);
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            var res:XML = super.getSelfXMLObject();
            
            // TODO: Сериализовать специфичные поля
            
            res.@id = triggerId;
            res.@value = triggerValue;
            res.@type = triggerValueType;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            triggerId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            triggerValue = data.hasOwnProperty("@value") ? Number(data.@value) : 0;
            triggerValueType = data.hasOwnProperty("@type") ? data.@type.toString() : TriggersProxy.SET;
            
            // /TODO
            
            return true;
        }
    }
}