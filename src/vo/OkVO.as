package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object обработчика Ok
     * 
     */
    
    public class OkVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "ok";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function OkVO()
        {
            super(NAME);
        }
        
        public function get okResult():ResultVO
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