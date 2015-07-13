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
		
		public static const CANCEL:uint = 1;				//< Код кнопки Cancel для алертов
		public static const OK:uint = 2;					//< Код кнопки Ok для алертов
		public static const YES:uint = 4;					//< Код кнопки Yes для алертов
		public static const NO:uint = 8;					//< Код кнопки No для алертов
        
        // Gender
        public static const MALE:String = "m";
        public static const FEMALE:String = "f";
        
        // Messages
        public static const MESSAGE:String = "message";
        public static const WARNING:String = "warning";
        public static const ERROR:String = "error";
		
		// Notifications
        public static const GAME_EVENT:String = "gameEvent";                                //< Произошло внутриигровое событие
		public static const CREATE_NEW_BASE:String = "createNewBase";						//< Запрос на создание новой базы
		public static const NEW_BASE_CREATED:String = "newBaseCreated";						//< Была создана новая база
		public static const RENAME_BASE:String = "renameBase";								//< Запрос на переименование базы
		public static const BASE_RENAMED:String = "baseRenamed";							//< База была переименована
        public static const CREATE_NEW_PERSON:String = "createNewPerson";                   //< Запрос на создание нового персонажа
        public static const NEW_PERSON_CREATED:String = "newPersonCreated";                 //< Был создан новый персонаж
        public static const PLACE_EMPLOYEE:String = "placeEmployee";                        //< Запрос на приписку сотрудника к базе
        public static const EMPLOYEE_IS_PLACED:String = "employeeIsPlaced";                 //< Сотрудник приписан к базе
        public static const CHANGE_RESOURCES:String = "changeResources";                    //< Изменить количество ресурсов
        public static const RESOURCES_CHANGED:String = "resourcesChanged";                  //< Изменилось количество ресурсов
        public static const ARTIFACT_FINDED:String = "artifactFinded";                      //< Найден артефакт
        public static const SEND_GAME_MESSAGE:String = "sendGameMessage";                   //< Отправить системное сообщение
        public static const GAME_MESSAGE_SENT:String = "gameMessageSent";                   //< Системное сообщение отправлено
        public static const OPEN_GAME_LOG:String = "openGameLog";                           //< Открыть лог игровых сообщений
        public static const OPEN_SHOP:String = "openShop";                                  //< Открыть магазин
        public static const BUILD_MODULE:String = "buildModule";                            //< Построить модуль
        public static const MODULES_CHANGED:String = "modulesChanged";                      //< Изменилось количество модулей одной из баз
        public static const REMOVE_MODULE:String = "removeModule";                          //< Удалить модуль
	}
}