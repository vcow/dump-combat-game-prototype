package dictionary
{
	import vo.VO;
	
	[ResourceBundle("resources")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека ресурсов
	 * 
	 */
	
	public final class ResourcesDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/resources.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:ResourcesDict;
		private static var _resources:Vector.<Resource>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static function getInstance():ResourcesDict
		{
			if (!_instance)
				_instance = new ResourcesDict();
			return _instance;
		}
		
		/**
		 * Получить информацию по ресурсу
		 * @param resourceId идентификатор ресурса
		 * @return информация по ресурсу
		 */
		public function getResource(resourceId:uint):Resource
		{
			if (!_resources)
			{
				_resources = new Vector.<Resource>();
				
				var src:XML = XML(new source());
				for each (var item:XML in src.resource)
				{
					var resource:Resource = new Resource();
					resource.id = item.hasOwnProperty("@id") ? uint(item.@id) : 0;
					resource.name = item.hasOwnProperty("@name") ? VO.parseString(item.@name, "resources") : Const.NO_TEXT;
					resource.description = item.hasOwnProperty("@description") ? VO.parseString(item.@description, "resources") : Const.NO_TEXT;
					resource.price = item.hasOwnProperty("@price") ? Number(item.@price) : 0.0;
					
					_resources.push(resource);
				}
			}
			
			for each (resource in _resources)
			{
				if (resource.id == resourceId)
					return resource;
			}
			return null;
		}
	}
}