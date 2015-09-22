package vo
{
    import dictionary.Const;
    
    /**
     * 
     * @author y.vircowskiy
     * Юнит в гарнизоне
     * 
     */
    
    public class MercenaryVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "mercenary";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var mercenaryUnitId:String;          // Идентификатор боевого юнита
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function MercenaryVO()
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
            
            res.@unit = mercenaryUnitId;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            mercenaryUnitId = data.hasOwnProperty("@unit") ? data.@unit.toString() : Const.NO_GUID;
            
            // /TODO
            
            return true;
        }
    }
}