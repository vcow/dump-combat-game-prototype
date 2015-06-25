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
		
		public function BaseVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		/**
		 * Получить список модулей базы указанного типа
		 * @param moduleId идентификатор типа модуля
		 * @return список модулей базы
		 */
		public function getModules(moduleId:uint):Vector.<ModuleVO>
		{
			var modules:Vector.<ModuleVO> = new Vector.<ModuleVO>();
			for (var i:int = 0; i < numChildren; i++)
            {
                var item:IVO = getChildAt(i);
				if (item.name == ModulesVO.NAME)
				{
					for (var j:int = 0; j < item.numChildren; j++)
					{
                        var module:ModuleVO = ModuleVO(item.getChildAt(j));
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
			for (var i:int = 0; i < numChildren; i++)
			{
                var value:IVO = getChildAt(i);
				if (value.name == StoreVO.NAME)
					return value as StoreVO;
			}
			return null;
		}
        
        /**
         * Персонал базы
         */
        public function get personnel():PersonnelVO
        {
            for (var i:int = 0; i < numChildren; i++)
            {
                var value:IVO = getChildAt(i);
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
	