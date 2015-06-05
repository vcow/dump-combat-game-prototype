package proxy
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.PersonVO;
    import vo.PersonsVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси игровых персонажей
     * 
     */
    
    public class PersonsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "personsProxy";
        
        protected static const FILE_NAME:String = "data/pers_data.xml"
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonsProxy()
        {
            super(NAME, new PersonsVO());
        }
        
        /**
         * Записать текущее состояние персонажей в файл
         */
        public function saveData():void
        {
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            
            var data:String = '<?xml version="1.0" encoding="utf-8"?>\n';
            data += personsVO.serialize().toXMLString();
            data.replace(/\n/g, File.lineEnding);
            
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeUTFBytes(data);
            stream.close();
        }
        
        public function get personsVO():PersonsVO
        {
            return data as PersonsVO;
        }
        
        /**
         * Обновить информацию в дочернем Value Object
         * @param child VO обновляемого персонажа
         * @param save сохранить состояние приложения после обновления
         */
        public function updatePerson(child:PersonVO, save:Boolean=true):void
        {
            for (var i:int = 0; i < personsVO.children.length; i++)
            {
                var value:PersonVO = PersonVO(personsVO.children[i]);
                if (value.personId == child.personId)
                {
                    personsVO.children.splice(i, 1);
                    break;
                }
            }
            
            personsVO.children.push(child);
            
            if (save)
                saveData();
        }
        
        /**
         * Получить информацию по персонажу
         * @param personId идентификатор персонажа
         * @return персонаж
         */
        public function getPersonById(personId:String):PersonVO
        {
            for each (var value:PersonVO in personsVO.children)
            {
                if (value.personId == personId)
                    return value;
            }
            return null;
        }
        
        //----------------------------------
        //  Mediator
        //----------------------------------
        
        override public function onRegister():void
        {
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            
            if (file.exists)
            {
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.READ);
                var data:XML = XML(stream.readUTFBytes(stream.bytesAvailable));
                stream.close();
                
                personsVO.deserialize(data);
            }
        }
    }
}