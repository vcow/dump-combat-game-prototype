package command
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.AppDataProxy;
	import proxy.ArmyProxy;
	import proxy.BasesListProxy;
	import proxy.EnemiesProxy;
	import proxy.EventsProxy;
	import proxy.InvestigationsProxy;
	import proxy.LogProxy;
	import proxy.PersonsProxy;
	import proxy.ProductionsProxy;
	import proxy.QuestsProxy;
	import proxy.RaidsProxy;
	import proxy.TimersProxy;
	import proxy.TriggersProxy;
	
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
			this.facade.registerProxy(new PersonsProxy());
			this.facade.registerProxy(new AppDataProxy());
            this.facade.registerProxy(new TriggersProxy());
            this.facade.registerProxy(new RaidsProxy());
            this.facade.registerProxy(new LogProxy());
            this.facade.registerProxy(new InvestigationsProxy());
            this.facade.registerProxy(new ProductionsProxy());
            this.facade.registerProxy(new ArmyProxy());
            this.facade.registerProxy(new EnemiesProxy());
            this.facade.registerProxy(new EventsProxy());
            this.facade.registerProxy(new TimersProxy());
            this.facade.registerProxy(new QuestsProxy());
		}
	}
}