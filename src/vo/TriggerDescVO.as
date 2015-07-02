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
		
        public var triggerId:uint;              //< Идентификатор триггера
        public var triggerName:String;          //< Название триггера
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
            res.@name = triggerName;
            
            if (triggerIsComputable)
                res.@computable = "true";
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            triggerId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
            triggerName = data.hasOwnProperty("@name") ? data.@name.toString() : "";
            triggerIsComputable = data.hasOwnProperty("@computable") ? data.@computable.toString().toLowerCase() == "true" : false;
			
			// /TODO
			
			return true;
		}
	}
}