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
        
        public function get baseModules():ModulesVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == ModulesVO.NAME)
                    return item as ModulesVO;
            }
            return null;
        }
		
		/**
		 * Получить список модулей базы указанного типа
		 * @param moduleId идентификатор типа модуля
		 * @return список модулей базы
		 */
		public function getModules(moduleId:uint):Vector.<ModuleVO>
		{
			var modules:Vector.<ModuleVO> = new Vector.<ModuleVO>();
            var allModules:ModulesVO = baseModules;
            if (allModules)
            {
				for each (var module:ModuleVO in allModules.children)
				{
					if (module.moduleId == moduleId && !module.moduleInactive && !module.moduleBuildTimer)
						modules.push(module);
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
        
        /**
         * Персонал базы
         */
        public function get basePersonnel():PersonnelVO
        {
            for each (var value:IVO in children)
            {
                if (value.name == PersonnelVO.NAME)
                    return value as PersonnelVO;
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
			
			baseId = data.hasOwnProperty("@id") ? data.@id.toString() : VO.createGUID();
			baseName = data.hasOwnProperty("@name") ? parseString(data.@name, "bases") : Const.NO_TEXT;
			
			// /TODO
			
			return true;
		}
	}
}
	