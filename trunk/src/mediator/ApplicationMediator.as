package mediator
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Медиатор приложения
	 * 
	 */
	
	public class ApplicationMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "dcAppMediator";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get application():proto
		{
			return viewComponent as proto;
		}
		
		//----------------------------------
		//  Mediator
		//----------------------------------
		
	}
}