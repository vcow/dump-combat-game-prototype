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
        
        public var weaponId:String;
        public var slotNum:int;
        public var itemId:String;
        public var itemsCount:int;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function UnitEvent(type:String, itemId:String, itemsCount:int, slotNum:int, weaponId:String,
                                  bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.weaponId = weaponId;
            this.slotNum = slotNum;
            this.itemId = itemId;
            this.itemsCount = itemsCount;
        }
        
        override public function clone():Event
        {
            return new UnitEvent(type, itemId, itemsCount, slotNum, weaponId, bubbles, cancelable);
        }
    }
}