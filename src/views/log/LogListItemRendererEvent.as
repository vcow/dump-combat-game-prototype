package views.log
{
    import flash.events.Event;
    
    public class LogListItemRendererEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const MESSAGE_IS_READED:String = "messageIsReaded";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var index:int;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function LogListItemRendererEvent(type:String, index:int, bubbles:Boolean=true, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.index = index;
        }
        
        override public function clone():Event
        {
            return new LogListItemRendererEvent(type, index, bubbles, cancelable);
        }
    }
}