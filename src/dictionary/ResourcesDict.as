package dictionary
{
	import vo.ResourceDescVO;
	
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
		private static var _resources:Vector.<ResourceDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function ResourcesDict()
        {
            if (_instance != null)
                throw Error("ResourcesDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
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
		public function getResource(resourceId:String):ResourceDescVO
		{
			if (!_resources)
			{
				_resources = new Vector.<ResourceDescVO>();
				
				var src:XML = XML(new source());
				var items:XMLList = src.child(ResourceDescVO.NAME);
				for each (var item:XML in items)
				{
					var resource:ResourceDescVO = new ResourceDescVO();
					resource.deserialize(item);
					_resources.push(resource);
				}
			}
			
			for each (resource in _resources)
			{
				if (resource.resourceId == resourceId)
					return resource;
			}
			return null;
		}
	}
}