package events
{
    import flash.events.Event;
    
    public class ArmyEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const EQUIP_UNIT_SELECTED:String = "equipUnitSelected";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var unitId:String;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArmyEvent(type:String, unitId:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.unitId = unitId;
        }
        
        override public function clone():Event
        {
            return new ArmyEvent(type, unitId, bubbles, cancelable);
        }
    }
}