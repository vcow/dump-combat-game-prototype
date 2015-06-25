package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object списка ресурсов
	 * 
	 */
	
	public class PriceVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "price";
		
		public static const PRICE:String = "price";
		public static const FEE:String = "fee";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var priceDetails:String;			//< Назначение цены
        public var priceEventId:String;         //< Идентификатор события
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function PriceVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@details = priceDetails;
            if (priceEventId)
                res.@event = priceEventId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			priceDetails = data.hasOwnProperty("@details") ? data.@details.toString() : PRICE;
            priceEventId = data.hasOwnProperty("@event") ? data.@event.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}