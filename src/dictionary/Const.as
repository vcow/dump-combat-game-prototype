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
        public static const EMPLOYEE_PROF_IS_CHANGED:String = "employeeProfIsChanged";      //< Изменена профессия сотрудника
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
        public static const TRIGGER_CHANGED:String = "triggerCchanged";                     //< Изменилось значение триггера
        public static const UPDATE_RESEARCH:String = "updateResearch";                      //< Изменить параметры активного исследования
        public static const COMPLETE_RESEARCH:String = "completeResearch";                  //< Команда на завершение исследования
        public static const RESEARCH_UPDATED:String = "researchUpdated";                    //< Изменились параметры исследования
        public static const RESEARCH_STARTED:String = "researchStarted";                    //< Исследование начато
        public static const RESEARCH_COMPLETED:String = "researchComplete";                 //< Исследование завершено
        public static const UPDATE_PRODUCTION:String = "updateProduction";                  //< Изменить параметры активного производства
        public static const COMPLETE_PRODUCTION:String = "completeProduction";              //< Команда на завершение производства
        public static const PRODUCTION_UPDATED:String = "productionUpdated";                //< Изменились параметры производства
        public static const PRODUCTION_STARTED:String = "productionStarted";                //< Производство начато
        public static const PRODUCTION_COMPLETED:String = "productionCompleted";            //< Производство завершено
        public static const PRODUCT_ITEM_COMPLETED:String = "productItemCompleted";         //< Завершено производство единицы продукции
        public static const REPLACE_PERSON:String = "firePerson";                           //< Удалить персонажа
        public static const PERSON_IS_REPLACED:String = "personIsFired";                    //< Персонаж удален
        public static const MOVE_PERSON:String = "movePerson";                              //< Перевести сотрудника
        public static const MOBILIZE_UNIT:String = "mobilizeUnit";                          //< Мобилизовать боевой юнит
        public static const UNIT_IS_MOBILIZED:String = "unitIsMobilized";                   //< Боевой юнит мобилизован
        public static const SELECT_WEAPON:String = "selectWeapon";                          //< Выбрать оружие для боевого юнита
        public static const WEAPON_SELECTED:String = "weaponSelected";                      //< Выбрано оружие для боевого юнита
        public static const RELOAD_WEAPON:String = "reloadWeapon";                          //< Перезарядить оружие
        public static const WEAPON_RELOADED:String = "weaponReloaded";                      //< Оружие перезаряжено
        public static const SELECT_ARMOR:String = "selectArmor";                            //< Выбрать броню
        public static const ARMOR_SELECTED:String = "armorSelected";                        //< Броня выбрана
        public static const RELOAD_UNIT:String = "reloadUnit";                              //< Перезарядить юнит
        public static const UNIT_RELOADED:String = "unitReloaded";                          //< Юнит перезаряжен
        public static const DESTROY_UNIT:String = "destroyUnit";                            //< Расформировать юнит
        public static const UNIT_DESTROYED:String = "untiDestroyed";                        //< Юнит расформирован
        public static const MOVE_UNIT:String = "moveUnit";                                  //< Перевести юнит на другую базу
        public static const UNIT_IS_PLACED:String = "unitIsPlaced";                         //< Юнит помещен на базу
        public static const QUEST_STARTED:String = "questStarted";                          //< Запущен новый квест
        public static const QUEST_FINISHED:String = "questFinished";                        //< Квест завершился
        public static const FOUND_RUINS:String = "foundRuins";                              //< Найдены руины
        public static const FIND_TARGET:String = "findTarget";                              //< Найти вражескую базу
        public static const TARGET_FOUND:String = "targetFound";                            //< Найдена вражеская база
        public static const ATTACK_BASE:String = "attackBase";                              //< Атаковать базу
        public static const CONFIRM_ATTACK_BASE:String = "confirmAttackBase";               //< Подтверждение атаки от юзера
        public static const TIMER_COMPLETE:String = "timerComplete";                        //< Завершил работу какой-то таймер
        public static const CAMPAIGN_BEGAN:String = "campaignBegan";                        //< Поход начался
        public static const CAMPAIGN_COMPLETED:String = "campaignCompleted";                //< Поход завершился
        public static const ASSAULT:String = "assault";                                     //< Инициировать штурм базы
        public static const DISBAND:String = "disband";                                     //< Расформировать отряд
	}
}