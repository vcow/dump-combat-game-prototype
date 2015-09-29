package events
{
    import flash.events.Event;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие UI юнита
     * 
     */
    
    public class UnitEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const SELECT_WEAPON:String = "selectWeapon";
        public static const SELECT_ARMOR:String = "selectArmor";
        public static const CHARGE_WEAPON:String = "chargeWeapon";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var slot:Vector.<int>;
        public var itemId:String;
        public var ammo:Array;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function UnitEvent(type:String, itemId:String, ammo:Array, slot:Vector.<int>, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.slot = slot;
            this.itemId = itemId;
            this.ammo = ammo;
        }
        
        override public function clone():Event
        {
            return new UnitEvent(type, itemId, ammo, slot, bubbles, cancelable);
        }
    }
}