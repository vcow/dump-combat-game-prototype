package events
{
    import flash.events.Event;
    
    /**
     * 
     * @author y.vircowskiy
     * Событие UI производства
     * 
     */
    
    public class ProductionEvent extends Event
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const START_PRODUCTION:String = "startProduction";
        public static const CHANGE_PRODUCTION_ENGINEERS_COUNT:String = "changeProductionEngineersCount";
        public static const CHANGE_PRODUCTS_COUNT:String = "changeProductsCount";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var productionId:String;
        public var numEngineers:int;
        public var numProducts:int;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionEvent(type:String, productionId:String, numEngineers:int, numProducts:int,
                                        bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            
            this.productionId = productionId;
            this.numEngineers = numEngineers;
            this.numProducts = numProducts;
        }
        
        override public function clone():Event
        {
            return new ProductionEvent(type, productionId, numEngineers, numProducts, bubbles, cancelable);
        }
    }
}