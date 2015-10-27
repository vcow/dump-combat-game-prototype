package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object обработчика No
     * 
     */
    
    public class NoVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "no";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function NoVO()
        {
            super(NAME);
        }
        
        public function get noResult():ResultVO
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