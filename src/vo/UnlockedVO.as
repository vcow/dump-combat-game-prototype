package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object списка неблокируемых элементов
	 * 
	 */
	
	public class UnlockedVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "unlocked";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function UnlockedVO()
		{
			super(NAME);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
	}
}