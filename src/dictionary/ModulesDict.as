package dictionary
{
	import vo.ModuleDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека модулей
	 * 
	 */
	
	public final class ModulesDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/modules.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:ModulesDict;
		private static var _modules:Vector.<ModuleDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function ModulesDict()
        {
            if (_instance != null)
                throw Error("ModulesDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():ModulesDict
		{
			if (!_instance)
				_instance = new ModulesDict();
			return _instance;
		}
		
		/**
		 * Получить информацию по модулю
		 * @param moduleId идентификатор модуля
		 * @return информация по модулю
		 */
		public function getModule(moduleId:uint):ModuleDescVO
		{
			
			for each (var module:ModuleDescVO in modules)
			{
				if (module.moduleId == moduleId)
					return module;
			}
			return null;
		}
        
        /**
         * Список модулей
         */
        public function get modules():Vector.<ModuleDescVO>
        {
            if (!_modules)
            {
                _modules = new Vector.<ModuleDescVO>();
                
                var src:XML = XML(new source());
                var items:XMLList = src.child(ModuleDescVO.NAME);
                for each (var item:XML in items)
                {
                    var module:ModuleDescVO = new ModuleDescVO();
                    module.deserialize(item);
                    _modules.push(module);
                }
            }
            return _modules;
        }
	}
}