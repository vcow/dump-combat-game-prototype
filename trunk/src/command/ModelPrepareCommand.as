package command
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.AppDataProxy;
	import proxy.BasesListProxy;
	import proxy.ResourcesListProxy;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Команда Подготовить Модель
	 * 
	 */
	
	public class ModelPrepareCommand extends SimpleCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModelPrepareCommand()
		{
			super();
		}
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
			this.facade.registerProxy(new BasesListProxy());
			this.facade.registerProxy(new ResourcesListProxy());
			this.facade.registerProxy(new AppDataProxy());
		}
	}
}