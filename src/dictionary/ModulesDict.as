package dictionary
{
	import vo.PriceVO;
	import vo.VO;
	
	[ResourceBundle("modules")]
	
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
		private static var _modules:Vector.<Module>;
		
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
		public function getModule(moduleId:uint):Module
		{
			if (!_modules)
			{
				_modules = new Vector.<Module>();
				
				var src:XML = XML(new source());
				for each (var item:XML in src.module)
				{
					var module:Module = new Module();
					module.id = item.hasOwnProperty("@id") ? uint(item.@id) : 0;
					module.name = item.hasOwnProperty("@name") ? VO.parseString(item.@name, "modules") : Const.NO_TEXT;
					module.description = item.hasOwnProperty("@description") ? VO.parseString(item.@description, "modules") : Const.NO_TEXT;
					module.space = item.hasOwnProperty("@space") ? Number(item.@space) : 0.0;
					module.chance = item.hasOwnProperty("@chance") ? Number(item.@chance) : 0.0;
					
					var prc:XMLList = item.child(PriceVO.NAME);
					if (prc.length() > 0)
						module.price.deserialize(prc[0]);
					
					_modules.push(module);
				}
			}
			
			for each (module in _modules)
			{
				if (module.id == moduleId)
					return module;
			}
			return null;
		}
	}
}