package events
{
    import flash.events.Event;
    
    public class BeginRaidEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const BEGIN_RAID:String = "beginRaid";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var units:Array;
        public var departureBase:String;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function BeginRaidEvent(type:String, departureBase:String, units:Array, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.departureBase = departureBase;
            this.units = units;
        }
        
        override public function clone():Event
        {
            return new BeginRaidEvent(type, departureBase, units, bubbles, cancelable);
        }
    }
}