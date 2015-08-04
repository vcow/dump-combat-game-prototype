package dictionary
{
	import vo.ProfessionDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека профессий
	 * 
	 */
	
	public final class ProfessionsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/professions.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:ProfessionsDict;
		private static var _professions:Vector.<ProfessionDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function ProfessionsDict()
        {
            if (_instance != null)
                throw Error("ProfessionsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():ProfessionsDict
		{
			if (!_instance)
				_instance = new ProfessionsDict();
			return _instance;
		}
		
		/**
		 * Получить информацию по профессии
		 * @param professionId идентификатор профессии
		 * @return информация по професии
		 */
		public function getProfession(professionId:String):ProfessionDescVO
		{
            init();
			
			for each (var profession:ProfessionDescVO in _professions)
			{
				if (profession.professionId == professionId)
					return profession;
			}
			return null;
		}
        
        /**
         * Получить список всех профессий
         */
        public function get professions():Vector.<ProfessionDescVO>
        {
            init();
            return _professions;
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