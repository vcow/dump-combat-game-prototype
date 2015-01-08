package dictionary
{
	import vo.BasesVO;
	import vo.ResourcesVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека значений по умолчанию
	 * 
	 */
	
	public final class DefaultsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/defaults.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:DefaultsDict;
		private static var _resourcesList:ResourcesVO;
		private static var _basesList:BasesVO;
		
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
		public function get resourcesList():ResourcesVO
		{
			if (!_resourcesList)
				parseSource();
			return _resourcesList;
		}
		
		/**
		 * Базы игрока по умолчанию
		 */
		public function get basesList():BasesVO
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
			_resourcesList = new ResourcesVO();
			var lst:XMLList = src.child(ResourcesVO.NAME);
			if (lst.length() > 0)
				_resourcesList.deserialize(lst[0]);
			
			// базы по умолчанию
			_basesList = new BasesVO();
			lst = src.child(BasesVO.NAME);
			if (lst.length() > 0)
				_basesList.deserialize(lst[0]);
		}
	}
}