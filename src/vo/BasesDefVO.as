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
		
		public function BasesDefVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		/**
		 * Получить список баз игрока по умолчанию
		 * @return сгенерированный список баз
		 */
		public function getDefaultBases():BasesVO
		{
			var bases:BasesVO = new BasesVO();
			for (var i:int = 0; i < numChildren; i++)
            {
                var value:IVO = getChildAt(i);
				if (value.name == RuinDefVO.NAME)
				{
					var ruinDef:RuinDefVO = value as RuinDefVO;
					var ruin:RuinVO = ruinDef ? BasesDict.getInstance().getRuinForBase(ruinDef.baseId) : null;
					if (ruin)
						bases.addChild(ruin);
				}
            }
			return bases;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
	}
}