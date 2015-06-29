package command
{
    import command.data.GameEventCmdData;
    import managers.EventsManager;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Произошло внутриигровое событие
     * 
     */
    
    public class GameEventCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function GameEventCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            if (!EventsManager.getInstance().isEventActive(notification.getType()))
                throw Error("Inactive game event (" + notification.getType() + ").");
            
            var bases:Vector.<BaseVO> = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBasesList();
			var out:GameEventCmdData = new GameEventCmdData();
			
			// Прокинуть евент по всем базам, отправить нотфикации, которые вернут value object-ы
            for each (var base:BaseVO in bases)
            {
                base.event(notification.getType(), out);
                
				for (var key:String in out.privateOut)
				{
					var data:Array = out.privateOut[key] as Array;
					if (data && data.length > 0)
					{
						for each (var body:Object in data)
							sendNotification(key, body, base.baseId);
					}
					else
					{
						sendNotification(key, base.baseId);
					}
				}
				
				out.reset();
            }
			
			for (key in out.commonOut)
			{
				data = out.commonOut[key] as Array;
				if (data && data.length > 0)
				{
					for each (body in data)
                        sendNotification(key, body);
				}
				else
				{
					sendNotification(key);
				}
			}
        }
    }
}