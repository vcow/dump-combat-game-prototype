package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object триггера
	 * 
	 */
	
	public class TriggerDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "triggerDesc";
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var triggerId:String;            //< Идентификатор триггера
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function TriggerDescVO()
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
			
			res.@id = triggerId;
            
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            triggerId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}