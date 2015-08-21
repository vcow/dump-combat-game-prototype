package vo
{
	import dictionary.Const;
	
	[ResourceBundle("common")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object библиотечных данных о профессии
	 * 
	 */
	
	public class ProfessionDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "professionDesc";
		
		public static const LABORER:String = "laborer";
		public static const SOLGIER:String = "solgier";
		public static const SCIENTIST:String = "scientist";
		public static const ENGINEER:String = "engineer";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var professionId:String;				//< Идентификатор профессии
		public var professionName:String;			//< Название профессии
        public var professionCategory:String;       //< Название категории работников
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ProfessionDescVO()
		{
			super(NAME);
		}
        
        /**
         * Стоимость найма сотрудника на эту профессию
         */
        public function get professionHiringCost():PriceVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == PriceVO.NAME && item is PriceVO && PriceVO(item).priceDetails == PriceVO.PRICE)
                    return item as PriceVO;
            }
            return null;
        }
        
        /**
         * Зарплата сотрудника этой профессии
         */
        public function get professionSalary():PriceVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == PriceVO.NAME && item is PriceVO && PriceVO(item).priceDetails == PriceVO.FEE)
                    return item as PriceVO;
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
			
			res.@id = professionId;
			res.@name = professionName;
            res.@category = professionCategory;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			professionId = data.hasOwnProperty("@id") ? data.@id.toString() : LABORER;
			professionName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "common") : Const.NO_TEXT;
            professionCategory = data.hasOwnProperty("@category") ? VO.parseString(data.@category, "common") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}