package ai.battle
{
    /**
     * 
     * @author y.vircowskiy
     * Поле боя
     * 
     */
    
    public class Field
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _width:int;
        private var _height:int;
        
        private var _field:Vector.<Vector.<Vector.<Combatant>>>;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Конструктор
         * @param width ширина поля
         * @param height высота поля
         */
        public function Field(width:int, height:int)
        {
            if (width <= 0 || height <= 0)
                throw Error("Wrong field size! Battle field can't be zero.");
            
            _width = width;
            _height = height;
            
            _field = new Vector.<Vector.<Combatant>>(_width);
            for (var i:int = 0; i < _width; i++)
            {
                var col:Vector.<Vector.<Combatant>> = new Vector.<Vector.<Combatant>>(_height);
                for (var j:int = 0; j < _height; j++)
                    col[j] = new Vector.<Combatant>();
                _field[i] = col;
            }
        }
        
        /**
         * Ширина поля
         */
        public function get width():int
        {
            return _width;
        }
        
        /**
         * Высота поля
         */
        public function get height():int
        {
            return _height;
        }
        
        /**
         * Поставить юнит в указанную позицию
         * @param unit юнит
         * @param x позиция по горизонтали
         * @param y позиция по вертикали
         * @param single флаг, указывающий ставить юнит только в свободную ячейку
         * @return true, если юнит установлен, false, если ячейка занята
         */
        public function setUnit(unit:Combatant, x:int, y:int, single:Boolean=true):Boolean
        {
            if (x >= 0 && x < _width && y >= 0 && y < _height && !_field[x][y])
            {
                var cell:Vector.<Combatant> = _field[x][y];
                if (!single || cell.length == 0)
                {
                    _field[x][y].push(unit);
                    
                    unit.x = x;
                    unit.y = y;
                    
                    return true;
                }
            }
            return false;
        }
        
        /**
         * Получить юниты из указанной позиции
         * @param x позиция по горизонтали
         * @param y позиция по вертикали
         * @return юниты в указанной позиции
         */
        public function getUnits(x:int, y:int):Vector.<Combatant>
        {
            return x >= 0 && x < _width && y >= 0 && y < _height ? _field[x][y] : null;
        }
    }
}