package vo
{
	import dictionary.Const;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object работника
	 * 
	 */
	
	public class CharacterVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "character";
		
		public static const LABORER:String = "laborer";
		public static const SOLDIER:String = "soldier";
		public static const SCIENTIST:String = "scientist";
		public static const ENGENEER:String = "engineer";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var characrterPersonId:String;			//< Уникальный идентификатор персонажа
		public var characterProfession:String;			//< Профессия работника
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function CharacterVO()
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
			
			res.@id = characrterPersonId;
			res.@profession = characterProfession;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			characrterPersonId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
			characterProfession = data.hasOwnProperty("@profession") ? data.@profession.toString() : LABORER;
			
			// /TODO
			
			return true;
		}
	}
}
	