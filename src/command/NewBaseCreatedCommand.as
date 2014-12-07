package command
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Была создана новая база
	 * 
	 */
	public class NewBaseCreatedCommand extends MacroCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function NewBaseCreatedCommand()
		{
			super();
		}
		
		//----------------------------------
		//  MacroCommand
		//----------------------------------
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(AppStateChangedCommand);
			addSubCommand(RenameBaseCommand);
		}
	}
}