package vo
{
	import dictionary.Const;
	
	[ResourceBundle("common")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object библиотечных данных о профессии
	 * 
	 */
	
	public class ProfessionDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "professionDesc";
		
		public static const LABORER:uint = 1;
		public static const SOLGIER:uint = 2;
		public static const SCIENTIST:uint = 3;
		public static const ENGENEER:uint = 4;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var professionId:uint;				//< Идентификатор профессии
		public var professionName:String;			//< Название профессии
        public var professionCategory:String;       //< Название категории работников
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ProfessionDescVO()
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
			
			res.@id = professionId;
			res.@name = professionName;
            res.@category = professionCategory;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			professionId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			professionName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "common") : Const.NO_TEXT;
            professionCategory = data.hasOwnProperty("@category") ? VO.parseString(data.@category, "common") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}