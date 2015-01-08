package dictionary
{
	import vo.BaseTemplVO;
	
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
		
		public static function getInstance():BasesDict
		{
			if (!_instance)
				_instance = new BasesDict();
			return _instance;
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