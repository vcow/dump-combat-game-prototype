package managers
{
    /**
     * 
     * @author y.vircowskiy
     * Аватарки персонажей
     * 
     */
    
    public class PersonAvatars
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        [Embed(source="../../assets/images/avatar/icon1.jpg", mimeType="image/jpeg")]
        public static const avatar01Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon2.jpg", mimeType="image/jpeg")]
        public static const avatar02Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon3.jpg", mimeType="image/jpeg")]
        public static const avatar03Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon4.jpg", mimeType="image/jpeg")]
        public static const avatar04Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon5.jpg", mimeType="image/jpeg")]
        public static const avatar05Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon6.jpg", mimeType="image/jpeg")]
        public static const avatar06Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon7.jpg", mimeType="image/jpeg")]
        public static const avatar07Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon8.jpg", mimeType="image/jpeg")]
        public static const avatar08Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon9.jpg", mimeType="image/jpeg")]
        public static const avatar09Class:Class;
        
        [Embed(source="../../assets/images/avatar/icon10.jpg", mimeType="image/jpeg")]
        public static const avatar10Class:Class;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonAvatars()
        {
            throw Error("PersonAvatars is a static library.");
        }
    }
}