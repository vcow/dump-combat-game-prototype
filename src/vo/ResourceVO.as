package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object ресурса
	 * 
	 */
	
	public class ResourceVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "resource";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var resourceId:uint;				//< Идентификатор ресурса
		public var resourceCount:int;			//< Количество ресурсов
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourceVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override public function clone():VO
		{
			var resource:ResourceVO = new ResourceVO();
			resource.resourceId = resourceId;
			resource.resourceCount = resourceCount;
			return resource;
		}
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = resourceId;
			res.@count = resourceCount;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			resourceId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			resourceCount = data.hasOwnProperty("@count") ? int(data.@count) : 0;
			
			// /TODO
			
			return true;
		}
	}
}