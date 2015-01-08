package vo
{
	import dictionary.Const;
	
	[ResourceBundle("bases")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object шаблон руин (из шаблона базы)
	 * 
	 */
	
	public class RuinTemplVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ruinTempl";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var ruinName:String;				//< Название развалин
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function RuinTemplVO()
		{
			super(NAME);
		}
		
		/**
		 * Стоимость восстановления базы
		 */
		public function get ruinRepairPrice():PriceVO
		{
			for each (var value:IVO in children)
			{
				if (value.name == PriceVO.NAME)
					return value as PriceVO;
			}
			return null;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@name = ruinName;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			ruinName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "bases") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}