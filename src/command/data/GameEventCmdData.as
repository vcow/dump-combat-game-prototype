package command.data
{
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author jvirkovskiy
	 * Данные результатов работы события
	 * 
	 */
	
	public class GameEventCmdData
	{
		public var commonOut:Dictionary = new Dictionary();				//< Специфичные для базы данные нотификации
		public var privateOut:Dictionary = new Dictionary();			//< Общие данные нотификации
		
		public function GameEventCmdData()
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