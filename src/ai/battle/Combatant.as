package ai.battle
{
    import vo.UnitVO;

    /**
     * 
     * @author y.vircowskiy
     * Участник боя
     * 
     */
    
    public class Combatant
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _unit:UnitVO;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var x:Number;
        public var y:Number;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function Combatant(unit:UnitVO)
        {
            _unit = unit;
        }
        
        public function get unit():UnitVO
        {
            return _unit;
        }
    }
}