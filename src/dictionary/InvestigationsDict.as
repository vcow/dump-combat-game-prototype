package dictionary
{
	import helpers.ConditionHelper;
	
	import vo.ResearchDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека исследований
	 * 
	 */
	
	public final class InvestigationsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/investigations.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:InvestigationsDict;
		private static var _investigations:Vector.<ResearchDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function InvestigationsDict()
        {
            if (_instance != null)
                throw Error("InvestigationsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():InvestigationsDict
		{
			if (!_instance)
				_instance = new InvestigationsDict();
			return _instance;
		}
        
        /**
         * Получить список исследований
         * @param complete флаг, указывающий включать в список завершенные исследования
         * @param availableOnly флаг, указывающий включать в список только доступные на данный момент исследования
         * @param visibleOnly флаг, указывающий включать в список только видимые на данный момент исследования
         * @return список исследований
         */
        public function getInvestigations(complete:Boolean=false, availableOnly:Boolean=true, visibleOnly:Boolean=true):Vector.<ResearchDescVO>
        {
            init();
            
            var res:Vector.<ResearchDescVO> = new Vector.<ResearchDescVO>();
            var conditionDecor:ConditionHelper = new ConditionHelper();
            
            for each (var research:ResearchDescVO in _investigations)
            {
                var researchIsComplete:Boolean = conditionDecor.parseCondition(research.researchCompleteCondition);
                if (complete)
                {
                    if (researchIsComplete)
                        res.push(research);
                    continue;
                }
                
                if (researchIsComplete)
                    continue;
                
                var researchIsAvailable:Boolean = conditionDecor.parseCondition(research.researchCondition);
                if (availableOnly && !researchIsAvailable)
                    continue;
                
                var researchIsVisible:Boolean = conditionDecor.parseCondition(research.researchVisibilityCondition);
                if (visibleOnly && !researchIsVisible)
                    continue;
                
                if (researchIsAvailable || researchIsVisible)
                    res.push(research);
            }
            
            return res;
        }
        
        /**
         * Получить описание исследования по его идентификатору
         * @param researchId идентификатор исследования
         * @return описание исследования
         */
        public function getResearch(researchId:String):ResearchDescVO
        {
            init();
            
            for each (var research:ResearchDescVO in _investigations)
            {
                if (research.researchId == researchId)
                    return research;
            }
            return null;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function init():void
        {
            if (!_investigations)
            {
                _investigations = new Vector.<ResearchDescVO>();
                
                var src:XML = XML(new source());
                for each (var item:XML in src.children())
                {
                    var research:ResearchDescVO = new ResearchDescVO();
                    research.deserialize(item);
                    _investigations.push(research);
                }
            }
        }
	}
}