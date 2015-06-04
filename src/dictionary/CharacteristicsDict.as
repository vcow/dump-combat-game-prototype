package dictionary
{
	import flash.utils.Dictionary;
	
	import vo.ProfessionDescVO;
	import vo.SkillDescVO;
	
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
        private static var _skills:Vector.<SkillDescVO>;
        private static var _dependencies:Dictionary;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
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
         * Получить информацию по способности персонажа
         * @param skillId идентификатор способности
         * @return информация по способности
         */
        public function getSkill(skillId:uint):SkillDescVO
        {
            init();
            
            for each (var skill:SkillDescVO in _skills)
            {
                if (skill.skillId == skillId)
                    return skill;
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
            if (!_professions || !_skills || !_dependencies)
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
                
                _skills = new Vector.<SkillDescVO>();
                
                var skills:XMLList = src.skills;
                for each (var skillDesc:XML in skills)
                {
                    items = skillDesc.child(SkillDescVO.NAME);
                    for each (item in items)
                    {
                        var skill:SkillDescVO = new SkillDescVO();
                        skill.deserialize(item);
                        _skills.push(skill);
                    }
                }
                
                // TODO: Дописать парсинг зависимостей
            }
        }
	}
}