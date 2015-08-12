package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object условия видимости
     * 
     */
    
    public class VisibilityVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "visibility";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _data:Object = {};
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function VisibilityVO()
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
            throw Error("Visibility is readOnly node.");
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