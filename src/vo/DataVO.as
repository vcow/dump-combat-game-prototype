package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object произвольных данных
     * 
     */
    
    public class DataVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "data";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _data:Object = {};
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function DataVO()
        {
            super(NAME);
        }
        
        public function get dataValue():Object
        {
            return _data;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            throw Error("Data is readOnly node.");
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