package vo
{
	import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object шаблона базы
	 * 
	 */
	
	public class BaseTemplVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "baseTempl";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var baseId:String;				//< Идентификатор базы
		public var baseName:String;				//< Название базы
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BaseTemplVO()
		{
			super(NAME);
		}
		
		/**
		 * Данные по руинам базы
		 */
		public function get baseRuin():RuinTemplVO
		{
			for each (var value:IVO in children)
			{
				if (value.name == RuinTemplVO.NAME)
					return value as RuinTemplVO;
			}
			return null;
		}
        
        /**
         * Данные по армии базы
         * @param level уровень базы, для которого запрашивается армия
         * @return данные по армии
         */
        public function getBaseArmy(level:int=0):ArmyVO
        {
            var l:LevelVO = getLevel(level);
            if (l)
            {
                for each (var value:IVO in l.children)
                {
                    if (value.name == ArmyVO.NAME)
                        return value as ArmyVO;
                }
            }
            return null;
        }
		
		/**
		 * Данные по модулям базы
         * @param level уровень базы, для которого запрашиваются модули
         * @return данные по модулям
         */
		public function getBaseModules(level:int=0):ModulesVO
		{
            var l:LevelVO = getLevel(level);
            if (l)
            {
    			for each (var value:IVO in l.children)
    			{
    				if (value.name == ModulesVO.NAME)
    					return value as ModulesVO;
    			}
            }
			return null;
		}
        
        /**
         * Вспомогательная функция получения подходящего уровня
         * @param level искомый уровень
         * @return ближайший подходящий уровень
         */
        private function getLevel(level:int):LevelVO
        {
            var currentLevel:LevelVO;
            for each (var item:IVO in children)
            {
                if (item.name == LevelVO.NAME)
                {
                    var l:LevelVO = LevelVO(item);
                    if (l.levelValue > level)
                    {
                        continue;
                    }
                    else if (l.levelValue == level)
                    {
                        currentLevel = l;
                        break;
                    }
                    else if (l.levelValue < level)
                    {
                        if (!currentLevel)
                        {
                            currentLevel = l;
                            continue;
                        }
                    
                        if (currentLevel.levelValue < l.levelValue)
                            currentLevel = l;
                    }
                }
            }
            return currentLevel;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = baseId;
			res.@name = baseName;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			baseId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
			baseName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "bases") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}