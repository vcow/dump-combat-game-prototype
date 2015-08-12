package facade
{
	import command.ArtifactFindedCommand;
	import command.BuildModuleCommand;
	import command.ChangeResourcesCommand;
	import command.CreateNewBaseCommand;
	import command.CreateNewPersonCommand;
	import command.GameEventCommand;
	import command.NewPersonCreatedCommand;
	import command.PlaceEmployeeCommand;
	import command.RemoveModuleCommand;
	import command.RenameBaseCommand;
	import command.ResourcesChangedCommand;
	import command.SendGameMessageCommand;
	import command.StartUpCommand;
	
	import dictionary.Const;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Фасад приложения
	 * 
	 */
	
	public class ProtoFacade extends Facade
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "dcFacade";
		public static const STARTUP:String = NAME + "StartUp";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static function getInstance():ProtoFacade
		{
			if (instance == null)
				instance = new ProtoFacade();
			return instance as ProtoFacade;
		}
		
		public function startup(stage:Object):void
		{
			sendNotification(STARTUP, stage);
		}
		
		//----------------------------------
		//  Facade
		//----------------------------------
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(STARTUP, StartUpCommand);
			registerCommand(Const.CREATE_NEW_BASE, CreateNewBaseCommand);
			registerCommand(Const.RENAME_BASE, RenameBaseCommand);
            registerCommand(Const.CREATE_NEW_PERSON, CreateNewPersonCommand);
            registerCommand(Const.NEW_PERSON_CREATED, NewPersonCreatedCommand);
            registerCommand(Const.PLACE_EMPLOYEE, PlaceEmployeeCommand);
            registerCommand(Const.GAME_EVENT, GameEventCommand);
            registerCommand(Const.CHANGE_RESOURCES, ChangeResourcesCommand);
            registerCommand(Const.ARTIFACT_FINDED, ArtifactFindedCommand);
            registerCommand(Const.SEND_GAME_MESSAGE, SendGameMessageCommand);
            registerCommand(Const.BUILD_MODULE, BuildModuleCommand);
            registerCommand(Const.REMOVE_MODULE, RemoveModuleCommand);
            registerCommand(Const.RESOURCES_CHANGED, ResourcesChangedCommand);
		}
	}
}