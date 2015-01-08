package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object руин под новую базу
	 * 
	 */
	
	public class RuinVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ruin";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var ruinId:String;				//< Уникальный идентификатор руин
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function RuinVO()
		{
			super(NAME);
		}
		
		/**
		 * Модули, сохранившиеся на этих руинах
		 */		
		public function get ruinModules():ModulesVO
		{
			for each (var value:IVO in children)
			{
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
			
			res.@id = ruinId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			ruinId = data.hasOwnProperty("@id") ? data.@id.toString() : VO.createUID();
			
			// /TODO
			
			return true;
		}
	}
}