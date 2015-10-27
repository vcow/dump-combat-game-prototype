package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object обработчика Cancel
     * 
     */
    
    public class CancelVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "cancel";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CancelVO()
        {
            super(NAME);
        }
        
        public function get cancelResult():ResultVO
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