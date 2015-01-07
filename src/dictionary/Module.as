package dictionary
{
	import vo.PriceVO;

	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотечные данные о модуле
	 * 
	 */
	
	public final class Module
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const HOUSING:uint = 1;
		public static const STORE:uint = 2;
		
		public var id:uint;						//< Идентификатор модуля
		public var name:String;					//< Наименование модуля
		public var description:String;			//< Описание модуля
		public var space:Number;				//< Вместительность модуля
		public var chance:Number;				//< Вероятность сохранения после захвата базы (1.0 ... 0.0)
		public var price:PriceVO =				//< Стоимость постройки
			new PriceVO();
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function Module()
		{
		}
	}
}