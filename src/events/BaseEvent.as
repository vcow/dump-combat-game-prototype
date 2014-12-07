package events
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Событие от интерфейса списка баз
	 * 
	 */
	
	public class BaseEvent extends Event
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const RENAME:String = "rename";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var baseId:String;
		public var data:Object;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BaseEvent(type:String, baseId:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.baseId = baseId;
			this.data = data;
		}
		
		//----------------------------------
		// Event
		//----------------------------------
		
		override public function clone():Event
		{
			return new BaseEvent(type, baseId, data, bubbles, cancelable);
		}
	}
}