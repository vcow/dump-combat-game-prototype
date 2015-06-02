package helpers
{
    /**
     * 
     * @author y.vircowskiy
     * Декоратор временных меток
     * 
     */
    
    public class TimeHelper
    {
        public function TimeHelper()
        {
        }
        
        /**
         * Преобразовать строковое представление времени вида ##h##m##s##, где значение перед h - часы,
         * значение перед m - минуты, значение перед s - секунды, значение после s - милисекунды в количество милисекунд.
         * @param value строка
         * @return количество милисекунд
         */
        public function strToTime(value:String):Number
        {
            var res:Number = 0;
            var str:String = value.toLowerCase();
            
            var index:int = str.search("h");
            if (index >= 0)
            {
                var x:Number = parseInt(str.substr(0, index));
                str = str.substr(index + 1);
                if (!isNaN(x) && x > 0)
                    res += x * 3600000.0;
            }
            
            index = str.search("m");
            if (index >= 0)
            {
                x = parseInt(str.substr(0, index));
                str = str.substr(index + 1);
                if (!isNaN(x) && x > 0)
                    res += x * 60000.0;
            }
            
            index = str.search("s");
            if (index >= 0)
            {
                x = parseInt(str.substr(0, index));
                str = str.substr(index + 1);
                if (!isNaN(x) && x > 0)
                    res += x * 1000.0;
            }
            
            x = parseInt(str);
            if (!isNaN(x) && x > 0)
                res += Math.floor(x);
            
            return res;
        }
        
        /**
         * Преобразовать количество милисекунд в строковое представление времени вида ##h##m##s##, где значение перед h - часы,
         * значение перед m - минуты, значение перед s - секунды, значение после s - милисекунды.
         * @param value количество милисекунд
         * @return строковое представление времени
         */
        public function timeToStr(value:Number):String
        {
            var res:String = "";
            var x:int = int(value / 3600000.0);
            if (x > 0)
                res += x + "h";
            
            x = int(value / 60000.0) % 60;
            if (x > 0)
                res += x + "m";
            
            x = int(value / 1000.0) % 60;
            if (x > 0)
                res += x + "s";
            
            x = int(value) % 1000;
            if (x > 0)
                res += x.toString();
            
            return res;
        }
    }
}