package managers.events
{
    import flash.events.Event;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие менеджера изображений
     * 
     */
    
    public class ImagesManagerEvent extends Event
    {
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        public static const LOADING_BEGIN:String = "loadingBegin";
        public static const LOADING_COMPLETE:String = "loadingComplete";
        public static const LOADING_ERROR:String = "loadingError";
        public static const IMAGE_READY:String = "imageReady";
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        public var data:Object;
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        public function ImagesManagerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.data = data;
        }
        
        override public function clone():Event
        {
            return new ImagesManagerEvent(type, data, bubbles, cancelable);
        }
    }
}