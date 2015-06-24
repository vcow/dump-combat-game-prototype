package dictionary.data
{
    import flash.events.TimerEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.Timer;
    
    /**
     * 
     * @author y.vircowskiy
     * Хранилище динамических данных, сохраняемых на диске
     * 
     */
    
    final public dynamic class Stuff
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const AUTOSAVE_INTERVAL:Number = 1000.0;
        
        private static const FILE_NAME:String = "data/stuff.json";
        
        private static var _instance:Stuff;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function Stuff()
        {
            if (_instance != null)
                throw Error("Stuff is singleton, use getInstance() to get it.");
            _instance = this;
            
            restore();
            
            var now:Number = (new Date()).time;
            if (hasOwnProperty("timestamp"))
            {
                this.exitTime = this.timestamp;                     //< Время завершения предыдущей сессии
                this.restoreTime = NaN;
            }
            else
            {
                this.beginingOfTime = now;                          //< Время начала игры
                this.timestamp = now;                               //< Текущая временная метка
                this.restoreTime = now;                             //< Время возобновления игры
            }
        }
        
        public static function getInstance():Stuff
        {
            if (!_instance)
                _instance = new Stuff();
            return _instance;
        }
        
        /**
         * Сохранить данные на диск
         */
        public function saveData():void
        {
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            
            var data:String = JSON.stringify(this);
            data.replace(/\n/g, File.lineEnding);
            
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeUTFBytes(data);
            stream.close();
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function restore():void
        {
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            if (file.exists)
            {
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.READ);
                var data:Object = JSON.parse(stream.readUTFBytes(stream.bytesAvailable));
                stream.close();
                
                for (var key:String in data)
                    this[key] = data[key];
            }
        }
    }
}