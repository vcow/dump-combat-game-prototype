package vo
{
	import dictionary.Const;
	
	[ResourceBundle("modules")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object описания модуля
	 * 
	 */
	
	public class ModuleDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "moduleDesc";
		
		public static const HOUSING:uint = 1;		//< Жилой модуль
		public static const STORE:uint = 2;			//< Складской модуль
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var moduleId:uint;				//< Идентификатор модуля
		public var moduleName:String;			//< Название модуля
		public var moduleDescription:String;	//< Описание модуля
		public var moduleSpace:int;				//< Вместительность модуля
		public var moduleChance:Number;			//< Вероятность сохранения при захвате базы
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModuleDescVO()
		{
			super(NAME);
		}
		
		/**
		 * Стоимость постройки модуля
		 */
		public function get modulePrice():PriceVO
		{
			for each (var value:IVO in children)
			{
				if (value.name == PriceVO.NAME)
				{
					var price:PriceVO = value as PriceVO;
					if (price && price.priceDetails == PriceVO.PRICE)
						return price;
				}
			}
			return null;
		}
		
		/**
		 * Стоимость эксплуатации модуля
		 */
		public function get moduleFee():PriceVO
		{
			for each (var value:IVO in children)
			{
				if (value.name == PriceVO.NAME)
				{
					var price:PriceVO = value as PriceVO;
					if (price && price.priceDetails == PriceVO.FEE)
						return price;
				}
			}
			return null;
		}
        
        /**
         * Время на постройку модуля
         */
        public function get moduleLeadTime():LeadTimeVO
        {
            for each (var value:IVO in children)
            {
                if (value.name == LeadTimeVO.NAME)
                    return value as LeadTimeVO;
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
			
			res.@id = moduleId;
			res.@name = moduleName;
			res.@description = moduleDescription;
			res.@space = moduleSpace;
			res.@chance = moduleChance;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			moduleName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "modules") : Const.NO_TEXT;
			moduleDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "modules") : Const.NO_TEXT;
			moduleSpace = data.hasOwnProperty("@space") ? int(data.@space) : 0;
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : 0.0;
			
			// /TODO
			
			return true;
		}
	}
}