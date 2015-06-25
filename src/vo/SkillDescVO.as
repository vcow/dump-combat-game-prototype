package vo
{
	import dictionary.Const;
	
	[ResourceBundle("common")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object библиотечных данных о способности персонажа
	 * 
	 */
	
	public class SkillDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "skillDesc";
		
		public static const STRENGTH:uint = 1;
		public static const STAMINA:uint = 2;
		public static const AGILITY:uint = 3;
		public static const INTELLECT:uint = 4;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var skillId:uint;				//< Идентификатор способности
		public var skillName:String;			//< Название способности
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function SkillDescVO()
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
			
			res.@id = skillId;
			res.@name = skillName;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			skillId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			skillName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "common") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}