package vo
{
    import dictionary.Const;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object активного квеста
	 * 
	 */
	
	public class QuestVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "quest";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var questId:String;                  //< Идентификатор квеста
        public var questStep:int;                   //< Текущий шаг квеста
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function QuestVO()
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
			
			res.@id = questId;
            res.@step = questStep;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            questId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            questStep = data.hasOwnProperty("@step") ? int(data.@step) : 0;
			
			// /TODO
			
			return true;
		}
	}
}