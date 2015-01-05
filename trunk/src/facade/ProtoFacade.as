package facade
{
	import command.BaseRenamedCommand;
	import command.CreateNewBaseCommand;
	import command.NewBaseCreatedCommand;
	import command.RenameBaseCommand;
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
			registerCommand(Const.NEW_BASE_CREATED, NewBaseCreatedCommand);
			registerCommand(Const.RENAME_BASE, RenameBaseCommand);
			registerCommand(Const.BASE_RENAMED, BaseRenamedCommand);
		}
	}
}