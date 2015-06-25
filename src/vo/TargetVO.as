package vo
{
	import dictionary.Const;
	
	[ResourceBundle("bases")]

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object вражеской базы
	 * 
	 */
	
	public class TargetVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "target";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var targetId:String;					//< Уникальный идентификатор вражеской базы
		public var targetName:String;				//< Название вражеской базы
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function TargetVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = targetId;
			res.@name = targetName;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			targetId = data.hasOwnProperty("@id") ? data.@id.toString() : VO.createGUID();
			targetName = data.hasOwnProperty("@name") ? parseString(data.@name, "bases") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}