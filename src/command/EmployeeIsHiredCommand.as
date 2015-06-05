package command
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Был нанят новый сотрудник
	 * 
	 */
	public class EmployeeIsHiredCommand extends MacroCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EmployeeIsHiredCommand()
		{
			super();
		}
		
		//----------------------------------
		//  MacroCommand
		//----------------------------------
		
		override protected function initializeMacroCommand():void
		{
//			addSubCommand(AppStateChangedCommand);
		}
	}
}