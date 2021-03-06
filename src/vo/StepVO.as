package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object шага квеста
     * 
     */
    
    public class StepVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "step";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function StepVO()
        {
            super(NAME);
        }
        
        /**
         * Награда, выдаваемая при переходе на шаг
         */
        public function get stepResult():ResultVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ResultVO.NAME)
                    return ResultVO(item);
            }
            return null;
        }
        
        /**
         * Цели шага
         */
        public function get stepTargets():StepTargetsVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == StepTargetsVO.NAME)
                    return StepTargetsVO(item);
            }
            return null;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
    }
}