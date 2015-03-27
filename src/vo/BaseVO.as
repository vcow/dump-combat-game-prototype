package vo
{
	import dictionary.Const;
	
	[ResourceBundle("bases")]

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object базы
	 * 
	 */
	
	public class BaseVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "base";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var baseId:String;			//< Уникальный идентификатор базы
		public var baseName:String;			//< Название базы
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BaseVO()
		{
			super(NAME);
		}
		
		/**
		 * Получить список модулей базы указанного типа
		 * @param moduleId идентификатор типа модуля
		 * @return список модулей базы
		 */
		public function getModules(moduleId:uint):Vector.<ModuleVO>
		{
			var modules:Vector.<ModuleVO> = new Vector.<ModuleVO>();
			for each (var item:IVO in children)
			{
				if (item.name == ModulesVO.NAME)
				{
					for each (var module:ModuleVO in item.children)
					{
						if (module.moduleId == moduleId)
							modules.push(module);
					}
					break;
				}
			}
			return modules;
		}
		
		/**
		 * Склад базы
		 */
		public function get baseStore():StoreVO
		{
			for each (var value:IVO in children)
			{
				if (value.name == StoreVO.NAME)
					return value as StoreVO;
			}
			return null;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = baseId;
			res.@name = baseName;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			baseId = data.hasOwnProperty("@id") ? data.@id.toString() : VO.createUID();
			baseName = data.hasOwnProperty("@name") ? parseString(data.@name, "bases") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}
	