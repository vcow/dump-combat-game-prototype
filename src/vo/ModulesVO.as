package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object списка модулей базы
	 * 
	 */
	
	public class ModulesVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "modules";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var modulesMaxCount:int;			//< Предельное количество модулей
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModulesVO()
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
			
			res.@maxCount = modulesMaxCount;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			modulesMaxCount = data.hasOwnProperty("@maxCount") ? int(data.@maxCount) : 0;
			
			// /TODO
			
			return true;
		}
	}
}