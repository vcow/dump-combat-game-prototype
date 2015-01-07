package dictionary
{
	import vo.ModulesVO;
	import vo.PriceVO;
	import vo.RuinVO;
	import vo.VO;
	
	[ResourceBundle("bases")]
	
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
		private static var _bases:Vector.<Base>;
		
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
		public function getBase(baseId:String):Base
		{
			init();
			
			for each (var base:Base in _bases)
			{
				if (base.id == baseId)
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
				_bases = new Vector.<Base>();
				
				var src:XML = XML(new source());
				for each (var item:XML in src.base)
				{
					var base:Base = new Base();
					base.id = item.hasOwnProperty("@id") ? item.@id.toString() : Const.NO_GUID;
					base.name = item.hasOwnProperty("@name") ? VO.parseString(item.@name, "bases") : Const.NO_TEXT;
					base.level = item.hasOwnProperty("@level") ? int(item.@level) : 0;
					
					var mdl:XMLList = item.child(ModulesVO.NAME);
					if (mdl.length() > 0)
						base.modules.deserialize(mdl[0]);
					
					var rns:XMLList = item.child(RuinVO.NAME);
					if (rns.length() > 0)
					{
						var ruinSrc:XML = rns[0];
						base.ruinName = ruinSrc.hasOwnProperty("@name") ? VO.parseString(ruinSrc.@name, "bases") : Const.NO_TEXT;
						
						var prc:XMLList = ruinSrc.child(PriceVO.NAME);
						if (prc.length() > 0)
							base.repairPrice.deserialize(prc[0]);
					}
					
					_bases.push(base);
				}
			}
		}
	}
}