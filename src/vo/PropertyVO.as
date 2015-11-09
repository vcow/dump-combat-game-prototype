package vo
{
    import dictionary.Const;
    
    /**
     * 
     * @author y.vircowskiy
     * Value Object собственности (врага)
     * 
     */
    
    public class PropertyVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "property";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var propertyId:String;           // Идентификатор собственности
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PropertyVO()
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
            
            res.@id = propertyId;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            propertyId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            
            // /TODO
            
            return true;
        }
    }
}