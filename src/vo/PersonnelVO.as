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
		
		public function PersonnelVO()
		{
			super(NAME);
		}
		
		/**
		 * Получить список работников
		 * @param profession профессия работников, если null, возвращаются все работники для указанной базы
		 * @param base база, для которой запрашиваются работники, если null, то возвращаются работники для всех баз
		 * @return список работников
		 */
		public function getPersonnel(profession:String=null, base:BaseVO=null):Vector.<CharacterVO>
		{
			var personnel:Vector.<CharacterVO> = new Vector.<CharacterVO>();
			return personnel;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
	}
}