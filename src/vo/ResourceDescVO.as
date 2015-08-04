package vo
{
	import dictionary.Const;
	
	[ResourceBundle("resources")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object библиотечных данных о ресурсе
	 * 
	 */
	
	public class ResourceDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "resourceDesc";
		
		public static const CASH:String = "cash";
		public static const FOOD:String = "food";
        public static const CUDGEL:String = "cudgel";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var resourceId:String;                       //< Идентификатор ресурса
        public var resourceName:String;                     //< Название ресурса
        public var resourceDescription:String;              //< Описание ресурса
        public var resourceSize:int;                        //< Размер ресурса в складских единицах
        public var resourcePrice:Number;                    //< Цена ресурса в деньгах
        public var resourceDescriptionInvestigated:String;  //< Расширенное описание ресурса после его исследования
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourceDescVO()
		{
			super(NAME);
		}
        
        /**
         * Признак того, что ресурс является артефактом
         */
        public function get isArtifact():Boolean
        {
            return Boolean(resourceDescriptionInvestigated);
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = resourceId;
			res.@name = resourceName;
			res.@description = resourceDescription;
			res.@size = resourceSize;
			res.@price = resourcePrice;
            
            if (resourceDescriptionInvestigated)
                res.@descriptionInvestigated = resourceDescriptionInvestigated;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			resourceId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			resourceName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "resources") : Const.NO_TEXT;
			resourceDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "resources") : Const.NO_TEXT;
			resourceSize = data.hasOwnProperty("@size") ? int(data.@size) : 0;
			resourcePrice = data.hasOwnProperty("@price") ? Number(data.@price) : 0.0;
            resourceDescriptionInvestigated = data.hasOwnProperty("@descriptionInvestigated") ?
                VO.parseString(data.@descriptionInvestigated, "resources") : "";
			
			// /TODO
			
			return true;
		}
	}
}