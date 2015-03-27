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
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var personId:String;			//< Уникальный идентификатор персонажа
		
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
			
			res.@id = personId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			personId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
			
			// /TODO
			
			return true;
		}
	}
}
	