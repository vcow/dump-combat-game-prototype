package views.ui
{
    public class Icons
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        [Embed(source="../../../assets/images/icons/cash_icon_small.jpg", mimeType="image/jpeg")]
        public static const smallIconCashClass:Class;
        
        [Embed(source="../../../assets/images/icons/food_icon_small.jpg", mimeType="image/jpeg")]
        public static const smallIconFoodClass:Class;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function Icons()
        {
            throw Error("Icons is a static library.");
        }
    }
}