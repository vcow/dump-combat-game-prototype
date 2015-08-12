package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object условия
     * 
     */
    
    public class ConditionVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "condition";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _data:Object = {};
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ConditionVO()
        {
            super(NAME);
        }
        
        public function get conditionData():Object
        {
            return _data;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            throw Error("Condition is readOnly node.");
            return null;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            // TODO: десериализовать специфичные поля
            
            _data = parseAsObject(data);
            
            // /TODO
            
            return true;
        }
    }
}