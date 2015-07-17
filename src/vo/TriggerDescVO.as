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
        public var triggerIsComputable:Boolean; //< Признак вычислимого триггера
		
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
            
            if (triggerIsComputable)
                res.@computable = "true";
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            triggerId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            triggerIsComputable = data.hasOwnProperty("@computable") ? data.@computable.toString().toLowerCase() == "true" : false;
			
			// /TODO
			
			return true;
		}
	}
}