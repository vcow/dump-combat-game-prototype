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
         * @param available флаг, указывающий включать в список только доступные на данный момент исследования
         * @param visible флаг, указывающий включать в список только видимые на данный момент исследования
         * @return список исследований
         */
        public function getInvestigations(available:Boolean=true, visible:Boolean=true):Vector.<ResearchDescVO>
        {
            init();
            
            var res:Vector.<ResearchDescVO> = new Vector.<ResearchDescVO>();
            var conditionDecor:ConditionHelper = new ConditionHelper();
            
            for each (var research:ResearchDescVO in _investigations)
            {
                if (available && !conditionDecor.parseCondition(research.researchCondition))
                    continue;
                
                if (visible && !conditionDecor.parseCondition(research.researchVisibilityCondition))
                    continue;
                
                res.push(research);
            }
            
            return res;
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