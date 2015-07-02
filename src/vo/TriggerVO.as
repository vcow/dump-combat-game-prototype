package vo
{
	import dictionary.TriggersDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object триггера
	 * 
	 */
	
	public class TriggerVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "trigger";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var triggerValue:Number;			//< Значение триггера
		
		private var _triggerId:uint;			//< Идентификатор триггера
		
		private var _triggerDesc:TriggerDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function TriggerVO()
		{
			super(NAME);
		}
		
		public function set triggerId(value:uint):void
		{
			if (value == _triggerId)
				return;
			
            _triggerId = value;
            _triggerDesc = TriggersDict.getInstance().getTriggerById(_triggerId);
		}
		
		public function get triggerId():uint
		{
			return _triggerId;
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
			
			res.@id = triggerId;
            
            if (!isNaN(triggerValue))
                res.@value = triggerValue;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            triggerId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
            triggerValue = data.hasOwnProperty("@value") ? Number(data.@value) : NaN;
			
			// /TODO
			
			return true;
		}
	}
}