package facade
{
	import command.ArtifactFindedCommand;
	import command.AssaultCommand;
	import command.AttackBaseCommand;
	import command.BuildModuleCommand;
	import command.ChangeResourcesCommand;
	import command.CompleteProductionCommand;
	import command.CompleteResearchCommand;
	import command.CreateNewBaseCommand;
	import command.CreateNewPersonCommand;
	import command.DestroyUnitCommand;
	import command.DisbandCommand;
	import command.FindTargetCommand;
	import command.FoundRuinsCommand;
	import command.GameEventCommand;
	import command.MobilizeUnitCommand;
	import command.MovePersonCommand;
	import command.MoveUnitCommand;
	import command.NewPersonCreatedCommand;
	import command.PlaceEmployeeCommand;
	import command.QuestStartedCommand;
	import command.ReloadUnitCommand;
	import command.ReloadWeaponCommand;
	import command.RemoveModuleCommand;
	import command.RenameBaseCommand;
	import command.ReplacePersonCommand;
	import command.ResourcesChangedCommand;
	import command.SelectArmorCommand;
	import command.SelectWeaponCommand;
	import command.SendGameMessageCommand;
	import command.StartUpCommand;
	import command.TimerCompleteCommand;
	import command.TriggerChangedCommand;
	import command.UpdateProductionCommand;
	import command.UpdateResearchCommand;
	
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
            registerCommand(Const.UPDATE_RESEARCH, UpdateResearchCommand);
            registerCommand(Const.COMPLETE_RESEARCH, CompleteResearchCommand);
            registerCommand(Const.UPDATE_PRODUCTION, UpdateProductionCommand);
            registerCommand(Const.COMPLETE_PRODUCTION, CompleteProductionCommand);
            registerCommand(Const.REPLACE_PERSON, ReplacePersonCommand);
            registerCommand(Const.MOVE_PERSON, MovePersonCommand);
            registerCommand(Const.MOBILIZE_UNIT, MobilizeUnitCommand);
            registerCommand(Const.SELECT_WEAPON, SelectWeaponCommand);
            registerCommand(Const.RELOAD_WEAPON, ReloadWeaponCommand);
            registerCommand(Const.SELECT_ARMOR, SelectArmorCommand);
            registerCommand(Const.RELOAD_UNIT, ReloadUnitCommand);
            registerCommand(Const.DESTROY_UNIT, DestroyUnitCommand);
            registerCommand(Const.MOVE_UNIT, MoveUnitCommand);
            registerCommand(Const.QUEST_STARTED, QuestStartedCommand);
            registerCommand(Const.TRIGGER_CHANGED, TriggerChangedCommand);
            registerCommand(Const.FOUND_RUINS, FoundRuinsCommand);
            registerCommand(Const.ATTACK_BASE, AttackBaseCommand);
            registerCommand(Const.FIND_TARGET, FindTargetCommand);
            registerCommand(Const.TIMER_COMPLETE, TimerCompleteCommand);
            registerCommand(Const.DISBAND, DisbandCommand);
            registerCommand(Const.ASSAULT, AssaultCommand);
		}
	}
}