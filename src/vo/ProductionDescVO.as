package vo
{
    import dictionary.Const;
    
    [ResourceBundle("production")]
    
    /**
     * 
     * @author y.vircowskiy
     * Value Object описания производства
     * 
     */
    
    public class ProductionDescVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "productionDesc";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var productionId:String;                     //< Идентификатор производства
        public var productionName:String;                   //< Наименование производства
        public var productionDescription:String;            //< Описание производства
        public var productionPrice:int;                     //< Стоимость производства в человеко-часах инженеров
        public var productionDanger:Number;                 //< Опасность производства
        public var productionEventId:String;                //< Идентификатор события, по которому происходит пересчет завершения производства единицы продукции
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ProductionDescVO()
        {
            super(NAME);
        }
        
        /**
         * Условие на возможность производства
         */
        public function get productionCondition():Object
        {
            for each (var item:IVO in children)
            {
                if (item.name == ConditionVO.NAME)
                    return ConditionVO(item).conditionData;
            }
            return {};
        }
        
        /**
         * Цена производства единицы продукции
         */
        public function get productionStartPrice():PriceVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == PriceVO.NAME)
                    return item as PriceVO;
            }
            return null;
        }
        
        /**
         * Результат производства единицы продукции
         */
        public function get productionResult():ResultVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ResultVO.NAME)
                    return item as ResultVO;
            }
            return null;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            var res:XML = super.getSelfXMLObject();
            
            // TODO: Сериализовать специфичные поля
            
            res.@id = productionId;
            res.@name = productionName;
            res.@description = productionDescription;
            res.@price = productionPrice;
            res.@danger = productionDanger;
            res.@event = productionEventId;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            productionId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            productionName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "production") : Const.NO_TEXT;
            productionDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "production") : Const.NO_TEXT;
            productionPrice = data.hasOwnProperty("@price") ? int(data.@price) : 0;
            productionDanger = data.hasOwnProperty("@danger") ? Number(data.@danger) : 0;
            productionEventId = data.hasOwnProperty("@event") ? data.@event.toString() : EventDescVO.DEFAULT_PRODUCT_EVENT;
            
            // /TODO
            
            return true;
        }
    }
}