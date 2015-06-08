package command
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Сотрудник был перемещен на другую базу
	 * 
	 */
	public class EmployeeIsPlacedCommand extends MacroCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EmployeeIsPlacedCommand()
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