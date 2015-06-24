package command
{
	import mediator.ApplicationMediator;
	import mediator.BasesListMediator;
	import mediator.ProfListMediator;
	import mediator.SimpleResourcesMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Команда Приготовить Представления
	 * 
	 */
	
	public class ViewPrepareCommand extends SimpleCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ViewPrepareCommand()
		{
			super();
		}
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
			var app:proto = notification.getBody() as proto;
			this.facade.registerMediator(new ApplicationMediator(app));
			this.facade.registerMediator(new BasesListMediator());
			this.facade.registerMediator(new SimpleResourcesMediator());
            this.facade.registerMediator(new ProfListMediator());
		}
	}
}