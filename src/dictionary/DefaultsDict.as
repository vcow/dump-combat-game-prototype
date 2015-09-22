package dictionary
{
	import vo.BasesDefVO;
	import vo.BasesVO;
	import vo.StoreVO;
	import vo.UnlockedVO;
	
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
        private static var _unlockedResourcesList:UnlockedVO;
		
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
			init();
			return _resourcesList;
		}
		
		/**
		 * Базы игрока по умолчанию
		 */
		public function get basesList():BasesVO
		{
			init();
			return _basesList;
		}
        
        /**
         * Ресурсы, не блокируемые при поступлении на склад, отключенный за неуплату
         */
        public function get unlockedResourcesList():UnlockedVO
        {
            init();
            return _unlockedResourcesList;
        }
		
		/**
		 * Парсинг значений по умолчанию
		 */
		private function init():void
		{
            if (!_resourcesList && !_basesList && !_unlockedResourcesList)
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
                
                // Ресурсы, не блокируемые при поступлении на склад, отключенный за неуплату
                _unlockedResourcesList = new UnlockedVO();
                lst = src.child(UnlockedVO.NAME);
                if (lst.length() > 0)
                    _unlockedResourcesList.deserialize(lst[0]);
            }
		}
	}
}