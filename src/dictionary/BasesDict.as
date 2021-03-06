package dictionary
{
	import vo.BaseTemplVO;
	import vo.ModuleVO;
	import vo.ModulesVO;
	import vo.RuinVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека баз
	 * 
	 */
	
	public final class BasesDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/bases.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:BasesDict;
		private static var _bases:Vector.<BaseTemplVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public function BasesDict()
        {
            if (_instance != null)
                throw Error("BasesDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
        
		public static function getInstance():BasesDict
		{
			if (!_instance)
				_instance = new BasesDict();
			return _instance;
		}
        
        /**
         * Список всех шаблонов баз
         */
        public function get bases():Vector.<BaseTemplVO>
        {
            return _bases;
        }
		
		/**
		 * Получить информацию по базе
		 * @param baseId идентификатор базы
		 * @return информация по базе
		 */
		public function getBase(baseId:String):BaseTemplVO
		{
			init();
			
			for each (var base:BaseTemplVO in _bases)
			{
				if (base.baseId == baseId)
					return base;
			}
			return null;
		}
		
		/**
		 * Сгенерировать руины базы на основании шаблона
		 * @param baseId идентификатор базы, для которой генерятся руины
         * @param level запрашиваемый уровень базы
		 * @return сгенерированный Value Object руин базы
		 */
		public function getRuinForBase(baseId:String, level:int=0):RuinVO
		{
			var ruin:RuinVO = new RuinVO();
			var base:BaseTemplVO = getBase(baseId);
			if (base)
			{
				ruin.ruinId = base.baseId;
				var ruinModules:ModulesVO = new ModulesVO();		// Сохранившиеся модули
				ruin.children.push(ruinModules);
				
				var modules:ModulesVO = base.getBaseModules(level);
				if (modules)
				{
					ruinModules.modulesMaxCount = modules.modulesMaxCount;
					
					for each (var module:ModuleVO in modules.children)
					{
						var chance:Number = module.moduleChance;	// Вероятность сохранения модуля в руинах после захвата базы
						if (isNaN(chance))
							chance = module.moduleDesc.moduleChance;
						
						if (Math.random() <= chance)
							ruinModules.children.push(module.clone());
					}
				}
			}
			return ruin;
		}
		
		/**
		 * Инициализация массива баз
		 */
		private function init():void
		{
			if (!_bases)
			{
				_bases = new Vector.<BaseTemplVO>();
				
				var src:XML = XML(new source());
				var items:XMLList = src.child(BaseTemplVO.NAME);
				for each (var item:XML in items)
				{
					var base:BaseTemplVO = new BaseTemplVO();
					base.deserialize(item);
					_bases.push(base);
				}
			}
		}
	}
}