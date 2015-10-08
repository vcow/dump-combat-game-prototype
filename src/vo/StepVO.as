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
         * Условие завершения шага
         */
        public function get stepCondition():Object
        {
            for each (var item:IVO in children)
            {
                if (item.name == CompleteVO.NAME)
                    return CompleteVO(item).conditionData;
            }
            return null;
        }
        
        /**
         * Награда, выдаваемая по завершении шага
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
         * Награда, выдаваемая при переходе на шаг
         */
        public function get stepReward():RewardVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == RewardVO.NAME)
                    return RewardVO(item);
            }
            return null;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
    }
}