package vo
{
    /**
     * 
     * @author y.vircowskiy
     * Value Object цели шага квеста
     * 
     */
    
    public class StepTargetVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "stepTarget";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function StepTargetVO()
        {
            super(NAME);
        }
        
        /**
         * Условие завершения шага
         */
        public function get stepTargetCondition():Object
        {
            for each (var item:IVO in children)
            {
                if (item.name == ConditionVO.NAME)
                    return ConditionVO(item).conditionData;
            }
            return null;
        }
        
        /**
         * Награда, выдаваемая по завершении шага
         */
        public function get stepTargetResult():ResultVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ResultVO.NAME)
                    return ResultVO(item);
            }
            return null;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
    }
}