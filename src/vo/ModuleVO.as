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
		public var moduleChance:Number;			//< Вероятность сохранения модуля после захвата базы
												//< (если не NaN, переопределяет значение из словаря модулей ModuleDescVO)
		
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
		
		override public function clone():VO
		{
			var res:ModuleVO = new ModuleVO();
			res.moduleId = moduleId;
			
			return res;
		}
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = moduleId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : NaN;
			
			// /TODO
			
			return true;
		}
	}
}