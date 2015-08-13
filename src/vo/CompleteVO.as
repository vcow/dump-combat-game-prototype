package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object условия на завершение
     * 
     */
    
    public class CompleteVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "complete";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _data:Object = {};
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CompleteVO()
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
            throw Error("Complete is readOnly node.");
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