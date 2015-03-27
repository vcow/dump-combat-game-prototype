package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object персонажей
	 * 
	 */
	
	public class StaffVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "staff";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function StaffVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			return true;
		}
	}
}