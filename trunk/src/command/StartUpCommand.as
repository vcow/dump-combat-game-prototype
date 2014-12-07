package command
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Команда Инициализировать приложение
	 * 
	 */
	
	public class StartUpCommand extends MacroCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function StartUpCommand()
		{
			super();
		}
		
		//----------------------------------
		//  MacroCommand
		//----------------------------------
		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ModelPrepareCommand);
			addSubCommand(ViewPrepareCommand);
		}
	}
}