package vo
{
	import dictionary.Const;
	
	[ResourceBundle("quests")]
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object квеста
	 * 
	 */
	
	public class QuestDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "questDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var questId:String;				//< Идентификатор квеста
		public var questName:String;			//< Название квеста
		public var questDescription:String; 	//< Описание квеста
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function QuestDescVO()
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
			
			res.@id = questId;
			res.@name = questName;
			res.@description = questDescription;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			questId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			questName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "quests") : Const.NO_TEXT;
			questDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "quests") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}