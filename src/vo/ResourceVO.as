package vo
{
	import dictionary.ResourcesDict;

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
		
		public var resourceCount:int;			//< Количество ресурсов
		
		private var _resourceId:String;			//< Идентификатор ресурса
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourceVO()
		{
			super(NAME);
		}
		
		public function set resourceId(value:String):void
		{
			if (value == _resourceId)
				return;
			
			_resourceId = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_resourceId);
		}
		
		public function get resourceId():String
		{
			return _resourceId;
		}
		
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
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
			
			resourceId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			resourceCount = data.hasOwnProperty("@count") ? int(data.@count) : 0;
			
			// /TODO
			
			return true;
		}
	}
}