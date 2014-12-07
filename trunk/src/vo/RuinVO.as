package vo
{
	import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object руин под новую базу
	 * 
	 */
	
	public class RuinVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ruin";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var ruinId:String;				//< Уникальный идентификатор руин
		public var ruinName:String;				//< Название руин
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function RuinVO()
		{
			super(NAME);
		}
		
		/**
		 * Стоимость постройки базы на этих руинах
		 */		
		public function get price():PriceVO
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
			
			res.@id = ruinId;
			res.@name = ruinName;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			ruinId = data.hasOwnProperty("@id") ? data.@id.toString() : VO.createUID();
			ruinName = data.hasOwnProperty("@name") ? parseString(data.@name) : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}