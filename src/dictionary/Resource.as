package dictionary
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотечные данные о ресурсе
	 * 
	 */
	
	public final class Resource
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const CASH:uint = 1;
		public static const FOOD:uint = 2;
		
		public var id:uint;						//< Идентификатор ресурса
		public var name:String;					//< Наименование ресурса
		public var description:String;			//< Описание ресурса
		public var price:Number;				//< Стоимость ресурса в деньгах
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function Resource()
		{
		}
	}
}