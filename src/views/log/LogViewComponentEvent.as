package views.log
{
    import flash.events.Event;
    
    public class LogViewComponentEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const MESSAGE_IS_READED:String = "messageIsReaded";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var messageIndex:int;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogViewComponentEvent(type:String, messageIndex:int, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.messageIndex = messageIndex;
        }
        
        override public function clone():Event
        {
            return new LogViewComponentEvent(type, messageIndex, bubbles, cancelable);
        }
    }
}