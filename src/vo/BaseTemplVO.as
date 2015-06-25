package vo
{
	import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object шаблона базы
	 * 
	 */
	
	public class BaseTemplVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "baseTempl";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var baseId:String;				//< Идентификатор базы
		public var baseName:String;				//< Название базы
		public var baseLevel:int;				//< Уровень базы
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function BaseTemplVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
		
		/**
		 * Данные по руинам базы
		 */
		public function get baseRuin():RuinTemplVO
		{
			for (var i:int = 0; i < numChildren; i++)
			{
                var value:IVO = getChildAt(i);
				if (value.name == RuinTemplVO.NAME)
					return value as RuinTemplVO;
			}
			return null;
		}
		
		/**
		 * Данные по модулям базы
		 */
		public function get baseModules():ModulesVO
		{
            for (var i:int = 0; i < numChildren; i++)
            {
                var value:IVO = getChildAt(i);
				if (value.name == ModulesVO.NAME)
					return value as ModulesVO;
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
			res.@level = baseLevel;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			baseId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
			baseName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "bases") : Const.NO_TEXT;
			baseLevel = data.hasOwnProperty("@level") ? int(data.@level) : 0;
			
			// /TODO
			
			return true;
		}
	}
}