package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object обработчика Yes
     * 
     */
    
    public class YesVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "yes";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function YesVO()
        {
            super(NAME);
        }
        
        public function get yesResult():ResultVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ResultVO.NAME)
                    return item as ResultVO;
            }
            return null;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
    }
}