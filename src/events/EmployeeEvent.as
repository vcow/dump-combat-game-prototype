package events
{
    import flash.events.Event;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие для сотрудника
     * 
     */
    
    public class EmployeeEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EmployeeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}