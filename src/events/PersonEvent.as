package events
{
    import flash.events.Event;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие персонажа
     * 
     */
    
    public class PersonEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const MOVE_PERSON:String = "movePerson";
        public static const FIRE_PERSON:String = "firePerson";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var personId:String;
        public var baseId:String;
        public var professionId:String;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonEvent(type:String, personId:String, baseId:String, professionId:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.personId = personId;
            this.baseId = baseId;
            this.professionId = professionId;
        }
        
        override public function clone():Event
        {
            return new PersonEvent(type, personId, baseId, professionId, bubbles, cancelable);
        }
    }
}