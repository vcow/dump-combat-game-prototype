package vo
{
    import dictionary.Const;
    
    import flashx.textLayout.formats.Float;

    [ResourceBundle("investigations")]
    
    /**
     * 
     * @author y.vircowskiy
     * Value Object описания исследования
     * 
     */
    
    public class ResearchDescVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "resourceDesc";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public var researchId:String;                       //< Идентификатор исследования
        public var researchTitle:String;                    //< Название исследования до завершения
        public var researchResultTitle:String;              //< Название исследования после завершения
        public var researchResultDescription:String;        //< Результаты исследования
        public var researchPrice:int;                       //< Стоимость исследования в человеко-часах ученых
        public var researchDanger:Float;                    //< Опасность исследования
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ResearchDescVO(name:String)
        {
            super(name);
        }
        
        public function get researchCondition():Object
        {
            for each (var child:IVO in children)
            {
                if (child.name == ConditionVO.NAME)
                    return ConditionVO(child).conditionData;
            }
            return {};
        }
        
        public function get researchVisibilityCondition():Object
        {
            for each (var child:IVO in children)
            {
                if (child.name == VisibilityVO.NAME)
                    return VisibilityVO(child).conditionData;
            }
            return {};
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            var res:XML = super.getSelfXMLObject();
            
            // TODO: Сериализовать специфичные поля
            
            res.@id = researchId;
            res.@title = researchTitle;
            res.@resultTitle = researchResultTitle;
            res.@resultDescription = researchResultDescription;
            res.@price = researchPrice;
            res.@danger = researchDanger;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            researchId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            researchTitle = data.hasOwnProperty("@title") ? VO.parseString(data.@title, "investigations") : Const.NO_TEXT;
            researchResultTitle = data.hasOwnProperty("@resultTitle") ? VO.parseString(data.@resultTitle, "investigations") : Const.NO_TEXT;
            researchResultDescription = data.hasOwnProperty("@resultDescription") ? VO.parseString(data.@resultDescription, "investigations") : Const.NO_TEXT;
            researchPrice = data.hasOwnProperty("@price") ? int(data.@price) : 0;
            researchDanger = data.hasOwnProperty("@danger") ? Number(data.@danger) : 0;
            
            // /TODO
            
            return true;
        }
    }
}