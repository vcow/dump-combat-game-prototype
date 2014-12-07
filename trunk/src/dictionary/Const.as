package dictionary
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Константы, применяемые в коде
	 * 
	 */
	
	public final class Const
	{
		public static const NO_TEXT:String = "???";			//< Не определенный текст
		
		public static const CANCEL:int = 0;					//< Код кнопки Cancel для алертов
		public static const OK:int = 1;						//< Код кнопки Ok для алертов
		public static const YES:int = 2;					//< Код кнопки Yes для алертов
		public static const NO:int = 3;						//< Код кнопки No для алертов
		
		// Notifications
		public static const CREATE_NEW_BASE:String = "createNewBase";						//< Запрос на создание новой базы
		public static const NEW_BASE_CREATED:String = "newBaseCreated";						//< Была создана новая база
		public static const RENAME_BASE:String = "renameBase";								//< Запрос на переименование базы
		public static const BASE_RENAMED:String = "baseRenamed";							//< База была переименована
	}
}