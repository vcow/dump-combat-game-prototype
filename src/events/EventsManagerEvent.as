package events
{
    import flash.events.Event;
    
    public class EventsManagerEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const TICK:String = "tick";
        public static const EVENT:String = "event";
        public static const EVENT_ACTIVATED:String = "eventActivated";
        public static const EVENT_DEACTIVATED:String = "eventDeactivated";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var eventId:String;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EventsManagerEvent(type:String, eventId:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.eventId = eventId;
        }
    }
}