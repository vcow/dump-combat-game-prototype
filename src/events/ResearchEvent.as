package events
{
    import flash.events.Event;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие UI исследований
     * 
     */
    
    public class ResearchEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const BEGIN_RESEARCH:String = "beginResearch";
        public static const CHANGE_RESEARCH_SCIENTISTS_COUNT:String = "changeResearchScientistsCount";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var researchId:String;
        public var numScientists:int;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ResearchEvent(type:String, researchId:String, numScientists:int, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.researchId = researchId;
            this.numScientists = numScientists;
        }
        
        override public function clone():Event
        {
            return new ResearchEvent(type, researchId, numScientists, bubbles, cancelable);
        }
    }
}