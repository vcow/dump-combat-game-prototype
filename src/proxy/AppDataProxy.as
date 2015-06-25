package proxy
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.ApplicationVO;
	import vo.IVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Проки данных приложения
	 * 
	 */
	
	public class AppDataProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "appDataProxy";
		
		protected static const FILE_NAME:String = "data/app_data.xml";
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function AppDataProxy()
		{
			super(NAME, new ApplicationVO());
		}
		
		public function get applicationVO():ApplicationVO
		{
			return data as ApplicationVO;
		}
        
        /**
         * Сериализуемый объект для хранения текущих внутриигровых состояний
         */
        public function get stuff():Object
        {
            return applicationVO.stuff;
        }
		
		/**
		 * Получить дочерний Value Object по его имени
		 * @param name имя
		 * @return дочерний объект
		 */
		public function getChildByName(name:String):IVO
		{
			for (var i:int = 0; i < applicationVO.numChildren; i++)
			{
                var value:IVO = applicationVO.getChildAt(i);
				if (value.name == name)
					return value;
			}
			return null;
		}
		
        /**
         * Записать текущее состояние приложения в файл
         */
        public function saveData():void
        {
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath(FILE_NAME);
            
            var data:String = '<?xml version="1.0" encoding="utf-8"?>\n';
            data += applicationVO.serialize().toXMLString();
            data.replace(/\n/g, File.lineEnding);
            
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeUTFBytes(data);
            stream.close();
        }
        
        /**
         * Обновить информацию в дочернем Value Object
         * @param child новый дочерний VO
         */
        public function updateChild(child:IVO):void
        {
            for (var i:int = 0; i < applicationVO.numChildren; i++)
            {
                var value:IVO = applicationVO.getChildAt(i);
                if (value.name == child.name)
                {
                    applicationVO.removeChildAt(i);
                    break;
                }
            }
            
            applicationVO.addChild(child);
        }
        
		//----------------------------------
		//  Proxy
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
				
				applicationVO.deserialize(data);
			}
		}
	}
}