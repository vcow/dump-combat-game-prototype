package command
{
	import dictionary.Const;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.BasesListProxy;
	
	import vo.BaseVO;
	
	public class RenameBaseCommand extends SimpleCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function RenameBaseCommand()
		{
			super();
		}
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
			var basesListProxy:BasesListProxy = this.facade.retrieveProxy(BasesListProxy.NAME) as BasesListProxy;
			var baseVO:BaseVO = basesListProxy ? basesListProxy.getBaseById(notification.getType()) as BaseVO : null;
			var newName:String = notification.getBody().toString();
			if (baseVO && baseVO.baseName != newName)
			{
				baseVO.baseName = newName;
				sendNotification(Const.BASE_RENAMED, baseVO);
			}
		}
	}
}