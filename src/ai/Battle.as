package ai
{
    import ai.battle.Field;
    
    import vo.UnitVO;

    /**
     * 
     * @author y.vircowskiy
     * Рассчет боя
     * 
     */
    
    public class Battle
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _army1:Vector.<UnitVO>;
        private var _army2:Vector.<UnitVO>;
        
        private var _winner:int;
        private var _log:Vector.<String> = new Vector.<String>();
        
        private var _field:Field;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Конструктор
         * @param army1 первая армия
         * @param army2 вторая армия
         */
        public function Battle(army1:Vector.<UnitVO>, army2:Vector.<UnitVO>)
        {
            _army1 = army1;
            _army2 = army2;
            
            if (_army1.length == 0 && _army2.length > 0)
                _winner = 2;
            else if (_army1.length > 0 && _army2.length == 0)
                _winner = 1;
            else if (_army1.length == 0 && _army2.length == 0)
                _winner = 0;
            else
                calcBattle();
        }
        
        /**
         * Победитель
         */
        public function get winner():int
        {
            return _winner;
        }
        
        /**
         * Лог боя
         */
        public function get log():Vector.<String>
        {
            return _log;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Расчитать бой
         */
        private function calcBattle():void
        {
            arrangeFighters();
        }
        
        private function arrangeFighters():void
        {
            
        }
    }
}