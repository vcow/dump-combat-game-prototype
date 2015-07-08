package events
{
    import flash.events.Event;
    
    import dictionary.Const;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие списка сотрудников
     * 
     */
    
    public class EmployeeListEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const CREATE_PERSON:String = "createPerson";
        public static const PLACE_EMPLOYEE:String = "placeEmployee";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var employeeName:String;
        public var employeeImage:String;
        public var employeeId:String;
        public var employeeGender:String;
        public var professionId:uint;
        public var baseId:String;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EmployeeListEvent(type:String, employeeId:String, employeeName:String=null, employeeImage:String=null,
                                          employeeGender:String=Const.MALE, professionId:uint=1, baseId:String=Const.NO_GUID,
                                          bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.employeeName = employeeName;
            this.employeeImage = employeeImage;
            this.employeeId = employeeId;
            this.employeeGender = employeeGender;
            this.professionId = professionId;
            this.baseId = baseId;
        }
        
        override public function clone():Event
        {
            return new EmployeeListEvent(type, employeeId, employeeName, employeeImage,
                employeeGender, professionId, baseId, bubbles, cancelable);
        }
    }
}