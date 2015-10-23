package vo
{
    import dictionary.Const;
    import dictionary.QuestsDict;

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
		
        public var questStep:int;                   //< Текущий шаг квеста
        
        private var _questId:String;
        private var _questDesc:QuestDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function QuestVO()
		{
			super(NAME);
		}
        
        /**
         * Идентификатор квеста
         */
        public function set questId(value:String):void
        {
            if (value == _questId)
                return;
            
            _questId = value;
            _questDesc = QuestsDict.getInstance().getQuest(_questId);
        }
        
        public function get questId():String
        {
            return _questId;
        }
        
        /**
         * Описание квеста
         */
        public function get questDecs():QuestDescVO
        {
            return _questDesc;
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