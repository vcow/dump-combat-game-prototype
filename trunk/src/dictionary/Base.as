package dictionary
{
	import vo.ModulesVO;
	import vo.PriceVO;

	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотечные данные по базе
	 * 
	 */
	
	public class Base
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var id:String;				//< Идентификатор базы
		public var name:String;				//< Наименование базы
		public var level:int;				//< Уровень базы
		public var modules:ModulesVO = 		//< Модули базы
			new ModulesVO();
		public var ruinName:String =		//< Наименование руин базы
			Const.NO_TEXT;
		public var repairPrice:PriceVO = 	//< Стоимость восстановления базы
			new PriceVO();
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function Base()
		{
		}
	}
}