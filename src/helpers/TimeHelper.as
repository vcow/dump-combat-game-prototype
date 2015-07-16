package helpers
{
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;

    [ResourceBundle("time")]
    
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
        
        /**
         * Преобразовать количество милисекунд в литературное строковое представление времени
         * @param time количество милисекунд
         * @return строковое представление
         */
        public function getTimeDescription(time:Number):String
        {
            var res:String = "";
            var resourceManager:IResourceManager = ResourceManager.getInstance();
            
            var x:int = int(time / 3600000.0);
            if (x > 0)
                res += resourceManager.getString("time", "hour" + getIndex(x), [ x ]);
            
            x = int(time / 60000.0) % 60;
            if (x > 0)
                res += (res ? " " : "") +  resourceManager.getString("time", "min" + getIndex(x), [ x ]);
            
            x = int(time / 1000.0) % 60;
            if (x > 0)
                res += (res ? " " : "") +  resourceManager.getString("time", "sec" + getIndex(x), [ x ]);
            
            return res;
        }
        
        private function getIndex(value:int):int
        {
            var num:int = value % 10;
            var decnum:int = value % 100;
            if (num == 1 && decnum != 11)
                return 1;
            if (decnum >= 10 && decnum <= 20)
                return 3;
            if (num >= 2 && num <= 4)
                return 2;
            return 3;
        }
    }
}