package proxy.data
{
    /**
     * 
     * @author y.vircowskiy
     * Запись лога
     * 
     */
    
    public class LogRecordData
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const TYPE_MESSAGE:uint = 1;
        public static const TYPE_WARNING:uint = 2;
        public static const TYPE_ERROR:uint = 3;
        
        public static const CHANNEL_GAME:uint = 1;
        public static const CHANNEL_SYSTEM:uint = 2;
        public static const CHANNEL_USER:uint = 3;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _index:int;
        private var _type:uint;
        private var _channel:uint;
        private var _time:Date;
        private var _message:String;
        private var _isNew:Boolean;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogRecordData(index:int, raw:String=null)
        {
            _index = index;
            
            if (raw)
                deserialize(raw);
        }
        
        /**
         * Индекс сообщения
         */
        public function get index():int
        {
            return _index;
        }
        
        /**
         * Тип сообщения
         */
        public function get type():uint
        {
            return _type;
        }
        
        /**
         * Канал сообщения
         */
        public function get channel():uint
        {
            return _channel;
        }
        
        /**
         * Время отправки сообщения
         */
        public function get time():Date
        {
            return _time;
        }
        
        /**
         * Текст сообщения
         */
        public function get message():String
        {
            return _message;
        }
        
        /**
         * Признак того, что сообщение еще не прочитано
         */
        public function get isNew():Boolean
        {
            return _isNew;
        }
        
        public function set isNew(value:Boolean):void
        {
            if (value == _isNew)
                return;
            
            _isNew = value;
        }
        
        public function setMessage(message:String, type:uint=1, channel:uint=1):void
        {
            _message = message;
            _type = type;
            _channel = channel;
            _time = new Date();
            _isNew = true;
        }
        
        /**
         * Форматированная строка-представление для сообщения
         */
        public function toString():String
        {
            switch (_type)
            {
                case TYPE_MESSAGE:
                    return '<font size="8">[' + timeString + ']</font> <font color="#646464">' + _message + '</font>';
                case TYPE_WARNING:
                    return '<font color="#9e0b0f"><font size="8">[' + timeString + ']</font> <b>' + _message + '</b></font>';
                case TYPE_ERROR:
                    return '<font color="#840000"><font size="8">[' + timeString + ']</font> <b>' + _message + '</b></font>';
            }
            return _message;
        }
        
        private function get timeString():String
        {
            var append:Function = function(raw:String):String {
                return raw.length < 2 ? "0" + raw : raw;
            };
            return append(_time.getDate().toString()) + "." +
                   append((_time.getMonth() + 1).toString()) + "." +
                   _time.getFullYear().toString() + " " +
                   append(_time.getHours().toString()) + ":" +
                   append(_time.getMinutes().toString());
        }
        
        /**
         * Сериализовать сообщение
         * @return сериализованное в JSON сообщение
         */
        public function serialize():String
        {
            var rawData:Object = {};
            rawData.type = type;
            rawData.channel = channel;
            rawData.time = time.time;
            rawData.message = message;
            
            if (_isNew)
                rawData["new"] = true;
            
            return JSON.stringify(rawData);
        }
        
        /**
         * Десериализовать входные данные
         * @param json входные данные в виде JSON-строки
         * @return true, если данные десериализованы успешно
         */
        public function deserialize(json:String):Boolean
        {
            try {
                var rawData:Object = JSON.parse(json);
                
                _type = rawData.hasOwnProperty("type") ? uint(rawData.type) : TYPE_MESSAGE;
                _channel = rawData.hasOwnProperty("channel") ? uint(rawData.channel) : CHANNEL_GAME;
                _time = rawData.hasOwnProperty("time") ? new Date(Number(rawData.time)) : new Date();
                _message = rawData.hasOwnProperty("message") ? rawData.message.toString() : "";
                _isNew = rawData.hasOwnProperty("new") ? Boolean(rawData["new"]) : false;
            }
            catch (e:Error) {
                return false;
            }
            return Boolean(_message);
        }
    }
}