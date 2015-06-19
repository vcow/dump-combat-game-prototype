package dictionary
{
	import vo.BasesDefVO;
	import vo.BasesVO;
	import vo.StoreVO;
	
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
		private static var _resourcesList:StoreVO;
		private static var _basesList:BasesVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function DefaultsDict()
        {
            if (_instance != null)
                throw Error("DefaultsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():DefaultsDict
		{
			if (!_instance)
				_instance = new DefaultsDict();
			return _instance;
		}
		
		/**
		 * Ресурсы игрока по умолчанию
		 */
		public function get resourcesList():StoreVO
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
			_resourcesList = new StoreVO();
			var lst:XMLList = src.child(StoreVO.NAME);
			if (lst.length() > 0)
				_resourcesList.deserialize(lst[0]);
			
			// базы по умолчанию
			lst = src.child(BasesDefVO.NAME);
			if (lst.length() > 0)
			{
				var basesDef:BasesDefVO = new BasesDefVO();
				basesDef.deserialize(lst[0]);
				_basesList = basesDef.getDefaultBases();
			}
			else
			{
				_basesList = new BasesVO();
			}
		}
	}
}