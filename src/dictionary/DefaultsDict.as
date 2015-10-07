package dictionary
{
	import vo.QuestDefVO;
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
        
        private var _unlockedResourcesList:UnlockedVO;
        private var _startQuestId:String;
		
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
		 * Базы игрока по умолчанию
		 */
		public function get startQuestId():String
		{
			init();
			return _startQuestId;
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
            if (!_startQuestId && !_unlockedResourcesList)
            {
                var src:XML = XML(new source());
                
                // Стартовый квест
                var lst:XMLList = src.child(QuestDefVO.NAME);
                if (lst.length() > 0)
                {
                    var questDef:QuestDefVO = new QuestDefVO();
                    questDef.deserialize(lst[0]);
                    _startQuestId = questDef.questDefId;
                }
                
                // Ресурсы, не блокируемые при поступлении на склад, отключенный за неуплату
                _unlockedResourcesList = new UnlockedVO();
                lst = src.child(UnlockedVO.NAME);
                if (lst.length() > 0)
                {
                    _unlockedResourcesList.deserialize(lst[0]);
                }
            }
		}
	}
}