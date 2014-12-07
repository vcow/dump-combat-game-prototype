package command
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * База была переименована
	 * 
	 */
	public class BaseRenamedCommand extends MacroCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BaseRenamedCommand()
		{
			super();
		}
		
		//----------------------------------
		//  MacroCommand
		//----------------------------------
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(AppStateChangedCommand);
		}
	}
}