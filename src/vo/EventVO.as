package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object внутриигрового события
	 * 
	 */
	
	public class EventVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "event";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var eventId:String;              //< Идентификатор внутриигрового события
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EventVO()
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
			
			res.@id = eventId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            eventId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}
	