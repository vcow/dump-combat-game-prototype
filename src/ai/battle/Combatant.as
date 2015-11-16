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
        
        public function Combatant(unit:UnitVO)
        {
            _unit = unit;
        }
        
        public function get unit():UnitVO
        {
            return _unit;
        }
        
        public function get unitId():String
        {
            return _unit.unitId;
        }
    }
}