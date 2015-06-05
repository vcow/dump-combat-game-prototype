package command
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Был создан новый персонаж
	 * 
	 */
	public class NewPersonCreatedCommand extends MacroCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function NewPersonCreatedCommand()
		{
			super();
		}
		
		//----------------------------------
		//  MacroCommand
		//----------------------------------
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(PersonChangedCommand);
		}
	}
}