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
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			priceDetails = data.hasOwnProperty("@details") ? data.@details.toString() : PRICE;
            
            if (data.hasOwnProperty("@event"))
            {
                // TODO: Дописать обработку евента
            }
			
			// /TODO
			
			return true;
		}
	}
}