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
		
		public static const CASH:uint = 1;
		public static const FOOD:uint = 2;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var resourceId:uint;				//< Идентификатор ресурса
		public var resourceName:String;			//< Название ресурса
		public var resourceDescription:String;	//< Описание ресурса
		public var resourceSize:int;			//< Размер ресурса в складских единицах
		public var resourcePrice:Number;		//< Цена ресурса в деньгах
        public var resourceIsArtifact:Boolean;  //< Ресурс является артефактом
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourceDescVO()
		{
			super(NAME);
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
            
            if (resourceIsArtifact)
                res.@artifact = "true";
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			resourceId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			resourceName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "resources") : Const.NO_TEXT;
			resourceDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "resources") : Const.NO_TEXT;
			resourceSize = data.hasOwnProperty("@size") ? int(data.@size) : 0;
			resourcePrice = data.hasOwnProperty("@price") ? Number(data.@price) : 0.0;
            resourceIsArtifact = data.hasOwnProperty("@artifact") ? data.@artifact.toString().toLowerCase() == "true" : false;
			
			// /TODO
			
			return true;
		}
	}
}