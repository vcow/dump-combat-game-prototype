package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object списка баз
	 * 
	 */
	
	public class BasesVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "bases";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BasesVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String, data:Object=null):void
        {
            for each (var value:VO in _children)
            {
                if (value.name == BaseVO.NAME)
                    value.event(eventId, data);
            }
        }
	}
}