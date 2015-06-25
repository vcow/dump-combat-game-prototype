package vo
{
	import dictionary.BasesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object списка баз игрока по умолчанию
	 * 
	 */
	
	public class BasesDefVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "basesDef";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BasesDefVO()
		{
			super(NAME);
		}
		
		/**
		 * Получить список баз игрока по умолчанию
		 * @return сгенерированный список баз
		 */
		public function getDefaultBases():BasesVO
		{
			var bases:BasesVO = new BasesVO();
			for each (var value:IVO in children)
			{
				if (value.name == RuinDefVO.NAME)
				{
					var ruinDef:RuinDefVO = value as RuinDefVO;
					var ruin:RuinVO = ruinDef ? BasesDict.getInstance().getRuinForBase(ruinDef.baseId) : null;
					if (ruin)
						bases.children.push(ruin);
				}
			}
			return bases;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
	}
}