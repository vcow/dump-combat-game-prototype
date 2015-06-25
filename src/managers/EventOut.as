package managers
{
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author jvirkovskiy
	 * Объект для возврата результатов работы события
	 * 
	 */
	
	public class EventOut
	{
		public var commonOut:Dictionary = new Dictionary();				//< Специфичные для базы данные нотификации
		public var privateOut:Dictionary = new Dictionary();			//< Общие данные нотификации
		
		public function EventOut()
		{
		}
		
		/**
		 * Сброс специфичных для базы данных
		 */
		public function reset():void
		{
			for each (var item:Object in privateOut)
			{
				privateOut = new Dictionary();
				return;
			}
		}
	}
}