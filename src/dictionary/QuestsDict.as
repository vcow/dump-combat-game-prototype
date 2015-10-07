package dictionary
{
	import vo.QuestDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека квестов
	 * 
	 */
	
	public final class QuestsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/quests.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:QuestsDict;
        
        private var _questsList:Vector.<QuestDescVO>;
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function QuestsDict()
        {
            if (_instance != null)
                throw Error("QuestsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():QuestsDict
		{
			if (!_instance)
				_instance = new QuestsDict();
			return _instance;
		}
        
        /**
         * Получить квест по его идентификатору
         * @param questId идентификатор квеста
         * @return квест
         */
        public function getQuest(questId:String):QuestDescVO
        {
            init();
            
            for each (var questDesc:QuestDescVO in _questsList)
            {
                if (questDesc.questId == questId)
                    return questDesc;
            }
            
            return null;
        }
		
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
		/**
		 * Парсинг квестов
		 */
		private function init():void
		{
            if (!_questsList)
            {
                _questsList = new Vector.<QuestDescVO>();
                
                var src:XML = XML(new source());
                for each (var quest:XML in src.child(QuestDescVO.NAME))
                {
                    var questDesc:QuestDescVO = new QuestDescVO();
                    questDesc.deserialize(quest);
                    _questsList.push(questDesc);
                }
            }
		}
	}
}