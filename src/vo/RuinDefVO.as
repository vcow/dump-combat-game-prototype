package vo
{
	import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object развалин из списка баз по умолчанию BasesDefVO
	 * 
	 */
	
	public class RuinDefVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ruinDef";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var baseId:String;					//< Идентификатор базы, которой принадлежат руины
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function RuinDefVO(parent:IVO=null)
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
			
			res.@id = baseId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			baseId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
			
			// /TODO
			
			return true;
		}
	}
}