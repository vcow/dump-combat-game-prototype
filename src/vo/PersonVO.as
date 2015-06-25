package vo
{
	import dictionary.Const;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object персонажа
	 * 
	 */
	
	public class PersonVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "person";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var personId:String;             //< Уникальный идентификатор персонажа
        public var personName:String;           //< Имя персонажа
        public var personGender:String;         //< Пол персонажа (m/f)
        public var personImage:String;          //< Изображение персонажа
        public var personProfessionId:uint;     //< Идентификатор профессии персонажа
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function PersonVO()
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
			
			res.@id = personId || Const.NO_GUID;
            res.@name = personName;
            res.@gender = personGender;
            
            if (personImage)
                res.@image = personImage;
            
            if (personProfessionId > 0)
                res.@profession = personProfessionId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			personId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            personName = data.hasOwnProperty("@name") ? data.@name.toString() : "";
            personGender = data.hasOwnProperty("@gender") ? data.@gender.toString() : Const.MALE;
            personImage = data.hasOwnProperty("@image") ? data.@image.toString() : null;
            personProfessionId = data.hasOwnProperty("@profession") ? uint(data.@profession) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	