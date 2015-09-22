package command
{
	import command.data.RenameCmdData;
	
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
            var data:RenameCmdData = notification.getBody() as RenameCmdData;
            if (data)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                var base:BaseVO = basesListProxy.getBase(data.renamedObjectId) as BaseVO;
                if (base && base.baseName != data.newObjectName)
                {
                    base.baseName = data.newObjectName;
                    sendNotification(Const.BASE_RENAMED, base);
                }
            }
		}
	}
}