package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object персонала базы
	 * 
	 */
	
	public class PersonnelVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "personnel";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function PersonnelVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		/**
		 * Получить список работников
		 * @param professionId идентификатор профессии работников, если -1, возвращаются все работники для указанной базы
		 * @return список работников
		 */
		public function getPersonnel(professionId:int=-1):Vector.<EmployeeVO>
		{
			var personnel:Vector.<EmployeeVO> = new Vector.<EmployeeVO>();
			return personnel;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
	}
}