package dictionary
{
	import vo.ProfessionDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека характеристик персонажей
	 * 
	 */
	
	public final class CharacteristicsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/characteristics.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:CharacteristicsDict;
		private static var _professions:Vector.<ProfessionDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function CharacteristicsDict()
        {
            if (_instance != null)
                throw Error("CharacteristicsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():CharacteristicsDict
		{
			if (!_instance)
				_instance = new CharacteristicsDict();
			return _instance;
		}
		
		/**
		 * Получить информацию по профессии
		 * @param professionId идентификатор профессии
		 * @return информация по професии
		 */
		public function getProfession(professionId:uint):ProfessionDescVO
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
                var professions:XMLList = src.professions;
                for each (var professionDesc:XML in professions)
                {
                    var items:XMLList = professionDesc.child(ProfessionDescVO.NAME);
                    for each (var item:XML in items)
                    {
                        var profession:ProfessionDescVO = new ProfessionDescVO();
                        profession.deserialize(item);
                        _professions.push(profession);
                    }
                }
            }
        }
	}
}