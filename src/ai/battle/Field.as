package ai.battle
{
    import vo.UnitVO;

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
        
        private var _field:Vector.<Vector.<UnitVO>>;
        
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
            
            _field = new Vector.<Vector.<UnitVO>>(_width);
            for (var i:int = 0; i < _width; i++)
                _field[i] = new Vector.<UnitVO>(_height);
        }
        
        /**
         * Поставить юнит в указанную позицию
         * @param unit юнит
         * @param x позиция по горизонтали
         * @param y позиция по вертикали
         * @return true, если юнит установлен, false, если ячейка занята
         */
        public function setUnit(unit:UnitVO, x:int, y:int):Boolean
        {
            if (x >= 0 && x < _width && y >= 0 && y < _height && !_field[x][y])
            {
                _field[x][y] = unit;
                return true;
            }
            return false;
        }
        
        /**
         * Получить юнит из указанной позиции
         * @param x позиция по горизонтали
         * @param y позиция по вертикали
         * @return юнит в указанной позиции
         */
        public function getUnit(x:int, y:int):UnitVO
        {
            return x >= 0 && x < _width && y >= 0 && y < _height ? _field[x][y] : null;
        }
    }
}