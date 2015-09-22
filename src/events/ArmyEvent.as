package events
{
    import flash.events.Event;
    
    public class ArmyEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const EQUIP_UNIT_SELECTED:String = "equipUnitSelected";
        public static const EQUIP:String = "equip";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var unitId:String;
        public var name:String;
        public var crew:Array;
        public var baseId:String;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArmyEvent(type:String, unitId:String, name:String=null, crew:Array=null,
                                  baseId:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.unitId = unitId;
            this.name = name;
            this.crew = crew;
            this.baseId = baseId;
        }
        
        override public function clone():Event
        {
            return new ArmyEvent(type, unitId, name, crew, baseId, bubbles, cancelable);
        }
    }
}