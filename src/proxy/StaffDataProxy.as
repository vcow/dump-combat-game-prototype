package proxy
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.PersonVO;
	import vo.StaffVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Проки данных персонажей
	 * 
	 */
	
	public class StaffDataProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "staffDataProxy";
		
		protected static const FILE_NAME:String = "data/staff_data.xml"
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function StaffDataProxy()
		{
			super(NAME, new StaffVO());
		}
		
		/**
		 * Записать текущее состояние персонажей в файл
		 */
		public function saveData():void
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(FILE_NAME);
			
			var data:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			data += staffVO.serialize().toXMLString();
			data.replace(/\n/g, File.lineEnding);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(data);
			stream.close();
		}
		
		public function get staffVO():StaffVO
		{
			return data as StaffVO;
		}
		
		/**
		 * Обновить информацию о персонаже
		 * @param person новый или модифицированный старый персонаж
		 * @param save сохранить состояние персонажей после обновления
		 */
		public function updatePerson(person:PersonVO, save:Boolean=true):void
		{
			for (var i:int = 0; i < staffVO.children.length; i++)
			{
				var value:PersonVO = PersonVO(staffVO.children[i]);
				if (value.personId == person.personId)
				{
					staffVO.children.splice(i, 1);
					break;
				}
			}
			
			staffVO.children.push(person);
			
			if (save)
				saveData();
		}
		
		/**
		 * Получить персонаж по его идентификатору
		 * @param id уникальный идентификатор персонажа
		 * @return персонаж
		 */
		public function getPerson(id:String):PersonVO
		{
			for each (var person:PersonVO in staffVO.children)
			{
				if (person.personId == id)
					return person;
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
				
				staffVO.deserialize(data);
			}
		}
	}
}