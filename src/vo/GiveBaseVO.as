package vo
{
    import dictionary.Const;
    
    /**
     * 
     * @author y.vircowskiy
     * Выдать юзеру базу
     * 
     */
    
    public class GiveBaseVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "giveBase";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var giveBaseId:String;           //< Идентификатор выдаваемой базы
        public var giveBaseAsRuin:Boolean;      //< Флаг, указывающий выдавать базу как руины
        public var giveBaseOwner:String;        //< Идентификатор владельца базы
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function GiveBaseVO()
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
            
            res.@id = giveBaseId;
            res.@asRuin = giveBaseAsRuin;
            res.@owner = giveBaseOwner;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            giveBaseId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            giveBaseAsRuin = data.hasOwnProperty("@asRuin") ? data.@asRuin.toString().toLowerCase() == "true" : false;
            giveBaseOwner = data.hasOwnProperty("@owner") ? data.@owner.toString() : "";
            
            // /TODO
            
            return true;
        }
    }
}