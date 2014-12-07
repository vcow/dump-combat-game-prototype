package dictionary
{
	import vo.BasesListVO;
	import vo.ResourcesListVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека значений по умолчанию
	 * 
	 */
	
	public class DefaultsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/defaults.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:DefaultsDict;
		private static var _resourcesList:ResourcesListVO;
		private static var _basesList:BasesListVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static function getInstance():DefaultsDict
		{
			if (!_instance)
				_instance = new DefaultsDict();
			return _instance;
		}
		
		/**
		 * Ресурсы игрока по умолчанию
		 */
		public function get resourcesList():ResourcesListVO
		{
			if (!_resourcesList)
				parseSource();
			return _resourcesList;
		}
		
		/**
		 * Базы игрока по умолчанию
		 */
		public function get basesList():BasesListVO
		{
			if (!_basesList)
				parseSource();
			return _basesList;
		}
		
		/**
		 * Парсинг значений по умолчанию
		 */
		private function parseSource():void
		{
			var src:XML = XML(new source());
			
			// ресурсы по умолчанию
			_resourcesList = new ResourcesListVO();
			var lst:XMLList = src.child(ResourcesListVO.NAME);
			if (lst.length() > 0)
				_resourcesList.deserialize(lst[0]);
			
			// базы по умолчанию
			_basesList = new BasesListVO();
			lst = src.child(BasesListVO.NAME);
			if (lst.length() > 0)
				_basesList.deserialize(lst[0]);
		}
	}
}