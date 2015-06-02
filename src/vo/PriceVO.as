package vo
{
    import helpers.TimeHelper;

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
        public var priceInterval:Number;        //< Интервал времени, через который снимается или начисляется платеж
		
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
            if (priceInterval)
                res.@interval = new TimeHelper().timeToStr(priceInterval);
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			priceDetails = data.hasOwnProperty("@details") ? data.@details.toString() : PRICE;
            priceInterval = data.hasOwnProperty("@interval") ? new TimeHelper().strToTime(data.@interval.toString()) : 0;
			
			// /TODO
			
			return true;
		}
	}
}