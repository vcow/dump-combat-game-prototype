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
		
		public static const HOUSING:String = "housing";		//< Жилой модуль
		public static const STORE:String = "store";			//< Складской модуль
        public static const LAB:String = "lab";             //< Лаборатория
        public static const WORKSHOP:String = "workshop";   //< Мастерская
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var moduleId:String;				//< Идентификатор модуля
		public var moduleName:String;			//< Название модуля
		public var moduleDescription:String;	//< Описание модуля
		public var moduleSpace:int;				//< Вместительность модуля
		public var moduleChance:Number;			//< Вероятность сохранения при захвате базы
        public var moduleBuiltEvent:String;     //< Идентификатор события, по которому модуль считается построенным
		
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
        public function get moduleTimeout():TimeoutVO
        {
            for each (var value:IVO in children)
            {
                if (value.name == TimeoutVO.NAME)
                    return value as TimeoutVO;
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
            
            if (moduleBuiltEvent)
                res.@builtEvent = moduleBuiltEvent;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			moduleName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "modules") : Const.NO_TEXT;
			moduleDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "modules") : Const.NO_TEXT;
			moduleSpace = data.hasOwnProperty("@space") ? int(data.@space) : 0;
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : 0.0;
            moduleBuiltEvent = data.hasOwnProperty("@builtEvent") ? data.@builtEvent.toString() : EventDescVO.DEFAULT_CONSTRUSTION_COMPLETED_EVENT;
			
			// /TODO
			
			return true;
		}
	}
}