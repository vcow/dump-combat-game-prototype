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
		public static const NO_GUID:String =				//< Не определенный GUID
			"00000000-0000-0000-0000-000000000000";
		
		public static const CANCEL:int = 0;					//< Код кнопки Cancel для алертов
		public static const OK:int = 1;						//< Код кнопки Ok для алертов
		public static const YES:int = 2;					//< Код кнопки Yes для алертов
		public static const NO:int = 3;						//< Код кнопки No для алертов
        
        // Gender
        public static const MALE:String = "m";
        public static const FEMALE:String = "f";
		
		// Notifications
		public static const CREATE_NEW_BASE:String = "createNewBase";						//< Запрос на создание новой базы
		public static const NEW_BASE_CREATED:String = "newBaseCreated";						//< Была создана новая база
		public static const RENAME_BASE:String = "renameBase";								//< Запрос на переименование базы
		public static const BASE_RENAMED:String = "baseRenamed";							//< База была переименована
        public static const CREATE_NEW_PERSON:String = "createNewPerson";                   //< Запрос на создание нового персонажа
        public static const NEW_PERSON_CREATED:String = "newPersonCreated";                 //< Был создан новый персонаж
        public static const PLACE_EMPLOYEE:String = "placeEmployee";                        //< Запрос на приписку сотрудника к базе
        public static const EMPLOYEE_IS_PLACED:String = "employeeIsPlaced";                 //< Сотрудник приписан к базе
	}
}