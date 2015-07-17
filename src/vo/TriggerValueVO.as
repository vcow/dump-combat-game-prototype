package vo
{
	import dictionary.TriggersDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object значения триггера
	 * 
	 */
	
	public class TriggerValueVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "triggerValue";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var triggerValueValue:Number;			//< Значение триггера
		
		private var _triggerValueTriggerId:String;		//< Идентификатор триггера
		
		private var _triggerDesc:TriggerDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function TriggerValueVO()
		{
			super(NAME);
		}
		
		public function set triggerValueTriggerId(value:String):void
		{
			if (value == _triggerValueTriggerId)
				return;
			
            _triggerValueTriggerId = value;
            _triggerDesc = TriggersDict.getInstance().getTrigger(_triggerValueTriggerId);
		}
		
		public function get triggerValueTriggerId():String
		{
			return _triggerValueTriggerId;
		}
		
		public function get triggerDesc():TriggerDescVO
		{
			return _triggerDesc;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = triggerValueTriggerId;
            
            if (!isNaN(triggerValueValue))
                res.@value = triggerValueValue;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            triggerValueTriggerId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            triggerValueValue = data.hasOwnProperty("@value") ? Number(data.@value) : NaN;
			
			// /TODO
			
			return true;
		}
	}
}