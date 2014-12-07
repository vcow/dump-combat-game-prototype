package events
{
	import flash.events.Event;
	
	import vo.IVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Событие от интерфейса списка баз
	 * 
	 */
	
	public class BasesListEvent extends Event
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const CREATE_BASE:String = "createBase";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var valueObject:IVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BasesListEvent(type:String, valueObject:IVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.valueObject = valueObject;
		}
		
		//----------------------------------
		// Event
		//----------------------------------
		
		override public function clone():Event
		{
			return new BasesListEvent(type, valueObject, bubbles, cancelable);
		}
	}
}