package command
{
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.LogProxy;
    import proxy.data.LogRecordData;
    
    public class SendGameMessageCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function SendGameMessageCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var text:String = notification.getBody().toString();
            var type:uint;
            switch (notification.getType())
            {
                case Const.WARNING: type = LogRecordData.TYPE_WARNING; break;
                case Const.ERROR: type = LogRecordData.TYPE_ERROR; break;
                default: type = LogRecordData.TYPE_MESSAGE;
            }
            
            var log:Vector.<LogRecordData> = LogProxy(this.facade.retrieveProxy(LogProxy.NAME)).log;
            var message:LogRecordData = new LogRecordData(log.length);
            message.setMessage(text, type, LogRecordData.CHANNEL_GAME);
            log.push(message);
            
            sendNotification(Const.GAME_MESSAGE_SENT, message);
        }
    }
}