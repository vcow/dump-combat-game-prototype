package dictionary
{
	import vo.ProfessionDescVO;
	
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
		private static var _professions:Vector.<ProfessionDescVO>;
		
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
		
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function init():void
        {
            if (!_professions)
            {
                _professions = new Vector.<ProfessionDescVO>();
                
                var src:XML = XML(new source());
                for each (var item:XML in src.children())
                {
                    var profession:ProfessionDescVO = new ProfessionDescVO();
                    profession.deserialize(item);
                    _professions.push(profession);
                }
            }
        }
	}
}