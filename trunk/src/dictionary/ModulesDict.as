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
		
		public static function getInstance():ResourcesDict
		{
			if (!_instance)
				_instance = new ResourcesDict();
			return _instance;
		}
		
		/**
		 * Получить информацию по модулю
		 * @param moduleId идентификатор модуля
		 * @return информация по модулю
		 */
		public function getModule(moduleId:uint):ModuleDescVO
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
			
			for each (module in _modules)
			{
				if (module.moduleId == moduleId)
					return module;
			}
			return null;
		}
	}
}