package proxy
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import proxy.data.LogRecordData;
    
    public class LogProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "logProxy";
        
        protected static const FILE_NAME:String = "data/log.txt";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogProxy(data:Vector.<LogRecordData>=null)
        {
            super(NAME, data);
        }
        
        public function get log():Vector.<LogRecordData>
        {
            return getData() as Vector.<LogRecordData>;
        }
        
        /**
         * Записать лог в файл
         * @param linesLimit максимальное количество записей, подлежащих сохранению
         */
        public function saveData(linesLimit:uint=500):void
        {
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            
            var data:String = "";
            var from:uint = log.length > linesLimit ? log.length - linesLimit : 0;
            
            for (var i:uint = from; i < log.length; i++)
                data += log[i].serialize() + File.lineEnding;
            
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeUTFBytes(data);
            stream.close();
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function onRegister():void
        {
            var log:Vector.<LogRecordData> = new Vector.<LogRecordData>();
            setData(log);
            
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            
            if (file.exists)
            {
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.READ);
                
                var raw:String = stream.readUTFBytes(stream.bytesAvailable);
                var lines:Array = raw.split("\n");
                
                var index:int = 0;
                for (var i:int = 0; i < lines.length; i++)
                {
                    var record:LogRecordData = new LogRecordData(index);
                    if (record.deserialize(lines[i]))
                    {
                        log.push(record);
                        index++;
                    }
                }
                
                stream.close();
            }
        }
    }
}