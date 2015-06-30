package managers.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для порезки изображения
     * 
     */
    public class ImageClipData implements IImageClipData
    {
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        private var _width:Number;
        private var _height:Number;
        private var _left:Number;
        private var _right:Number;
        private var _top:Number;
        private var _bottom:Number;
        
        private var _horizontal:Boolean;
        private var _stretchStart:Number;
        private var _stretchSize:Number;
        
        private var _stretchLeft:Number;
        private var _stretchTop:Number;
        private var _stretchWidth:Number;
        private var _stretchHeight:Number;
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        /**
         * Общая ширина изображения
         */
        public function get width():Number
        {
            return _width;
        }
        
        public function set width(value:Number):void
        {
            if (value == _width)
                return;
            
            _width = value;
            
            if (isNaN(_left) || isNaN(_right))
            {
                if (!isNaN(_stretchStart) && !isNaN(_stretchSize) && _horizontal)
                {
                    _left = Math.min(_stretchStart, _width);
                    _right = Math.max(_width - (_stretchStart + _stretchSize), 0);
                }
                else if (!isNaN(_stretchLeft) && !isNaN(_stretchWidth))
                {
                    _left = Math.min(_stretchLeft, _width);
                    _right = Math.max(_width - (_stretchLeft + _stretchWidth), 0);
                }
                else
                {
                    _left = isNaN(_left) ? 0 : _left;
                    _right = isNaN(_right) ? 0 : _right;
                }
            }
        }
        
        /**
         * Общая высота изображения
         */
        public function get height():Number
        {
            return _height;
        }
        
        public function set height(value:Number):void
        {
            if (value == _height)
                return;
            
            if (isNaN(_top) || isNaN(_bottom))
            {
                if (!isNaN(_stretchStart) && !isNaN(_stretchSize) && !_horizontal)
                {
                    _top = Math.min(_stretchStart, _height);
                    _bottom = Math.max(_height - (_stretchStart + _stretchSize), 0);
                }
                else if (!isNaN(_stretchTop) && !isNaN(_stretchHeight))
                {
                    _top = Math.min(_stretchTop, _height);
                    _bottom = Math.max(_height - (_stretchTop + _stretchHeight), 0);
                }
                else
                {
                    _top = isNaN(_top) ? 0 : _top;
                    _bottom = isNaN(_bottom) ? 0 : _bottom;
                }
            }
        }
        
        /**
         * Левая граница порезки
         */
        public function get left():Number
        {
            return _left;
        }
        
        public function set left(value:Number):void
        {
            if (value == _left)
                return;
            
            _left = value;
        }
        
        /**
         * Правая граница порезки
         */
        public function get right():Number
        {
            return _right;
        }
        
        public function set right(value:Number):void
        {
            if (value == _right)
                return;
            
            _right = value;
        }
        
        /**
         * Верзняя граница порезки
         */
        public function get top():Number
        {
            return _top;
        }
        
        public function set top(value:Number):void
        {
            if (value == _top)
                return;
            
            _top = value;
        }
        
        /**
         * Нижняя граница порезки
         */
        public function get bottom():Number
        {
            return _bottom;
        }
        
        public function set bottom(value:Number):void
        {
            if (value == _bottom)
                return;
            
            _bottom = value;
        }
        
        /**
         * Задать данные для порезки на три части
         * @param stretchStart начало растягиваемой области изображения
         * @param stretchSize размер растягиваемой области изображения
         * @param horizontal если true, растягивание производится в горизонтальной плоскости, иначе - в вертикальной
         */
        public function setScale3(stretchStart:Number, stretchSize:Number, horizontal:Boolean):void
        {
            _stretchStart = stretchStart;
            _stretchSize = stretchSize;
            _horizontal = horizontal;
            
            if (horizontal)
            {
                if (!isNaN(_width))
                {
                    _left = Math.min(_stretchStart, _width);
                    _right = Math.max(_width - (_stretchStart + _stretchSize), 0);
                }
                
                if (!isNaN(_height))
                {
                    _top = isNaN(_top) ? 0 : _top;
                    _bottom = isNaN(_bottom) ? 0 : _bottom;
                }
            }
            else
            {
                if (!isNaN(_width))
                {
                    _left = isNaN(_left) ? 0 : _left;
                    _right = isNaN(_right) ? 0 : _right;
                }
                
                if (!isNaN(_height))
                {
                    _top = Math.min(_stretchStart, _height);
                    _bottom = Math.max(_height - (_stretchStart + _stretchSize), 0);
                }
            }
        }
        
        /**
         * Задать данные для порезки на девять частей для стретча по всем направлениям
         * @param left отступ слева до начала растягиваемой области
         * @param top отступ сверху до начала растягиваемой области
         * @param stretchWidth ширина растягиваемой области
         * @param stretchHeight высота растягиваемой области
         */
        public function setScale9(left:Number, top:Number, stretchWidth:Number, stretchHeight:Number):void
        {
            _stretchLeft = left;
            _stretchTop = top;
            _stretchWidth = stretchWidth;
            _stretchHeight = stretchHeight;
            
            if (!isNaN(_width))
            {
                _left = Math.min(_stretchLeft, _width);
                _right = Math.max(_width - (_stretchLeft + _stretchWidth), 0);
            }
            
            if (!isNaN(_height))
            {
                _top = Math.min(_stretchTop, _height);
                _bottom = Math.max(_height - (_stretchTop + _stretchHeight), 0);
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        public function ImageClipData()
        {
        }
    }
}