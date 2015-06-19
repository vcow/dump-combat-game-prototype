package proxy
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import dictionary.Const;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.ApplicationVO;
	import vo.IVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Проки данных приложения
	 * 
	 */
	
	public class AppDataProxy extends Proxy implements IVariableDataProxy
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "appDataProxy";
		
		protected static const FILE_NAME:String = "data/app_data.xml"
		
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
		 * Получить дочерний Value Object по его имени
		 * @param name имя
		 * @return дочерний объект
		 */
		public function getChildByName(name:String):IVO
		{
			for each (var value:IVO in applicationVO.children)
			{
				if (value.name == name)
					return value;
			}
			return null;
		}
		
        //----------------------------------
        //  IVariableDataProxy
        //----------------------------------
        
        /**
         * Записать текущее состояние приложения в файл
         * @param immediately флаг, указывающий сохранить данные немедленно
         */
        public function saveData(immediately:Boolean=false):void
        {
            if (immediately)
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
            else
            {
                sendNotification(Const.SAVE_DATA, this);
            }
        }
        
        /**
         * Обновить информацию в дочернем Value Object
         * @param child новый дочерний VO
         */
        public function updateChild(child:IVO):void
        {
            for (var i:int = 0; i < applicationVO.children.length; i++)
            {
                var value:IVO = applicationVO.children[i];
                if (value.name == child.name)
                {
                    applicationVO.children.splice(i, 1);
                    break;
                }
            }
            
            applicationVO.children.push(child);
            
            saveData();
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
				
				applicationVO.deserialize(data);
			}
		}
	}
}