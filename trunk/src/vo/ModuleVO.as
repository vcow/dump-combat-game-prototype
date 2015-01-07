package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object модуля
	 * 
	 */
	
	public class ModuleVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "module";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var moduleId:uint;				//< Идентификатор модуля
		public var moduleFilled:Number;			//< Заполнение модуля
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModuleVO()
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
			
			res.@id = moduleId;
			res.@filled = moduleFilled;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			moduleFilled = data.hasOwnProperty("@filled") ? Number(data.@filled) : 0.0;
			
			// /TODO
			
			return true;
		}
	}
}