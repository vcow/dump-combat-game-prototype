package vo
{
    import command.data.GameEventCmdData;
    
    import dictionary.InvestigationsDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object активного исследования
	 * 
	 */
	
	public class ResearchVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "research";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var researchPercent:Number = 0;          //< Процент завершения исследования (значение от 0 до 1.0)
        
		private var _researchId:String;
        private var _researchDesc:ResearchDescVO;
        private var _researchEvent:String;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResearchVO()
		{
			super(NAME);
		}
        
        /**
         * Уникальный идентификатор исследования
         */
        public function set researchId(value:String):void
        {
            if (value == _researchId)
                return;
            
            _researchId = value;
            _researchDesc = InvestigationsDict.getInstance().getResearch(_researchId);
            _researchEvent = _researchDesc ? _researchDesc.researchEventId : "";
        }
        
        public function get researchId():String
        {
            return _researchId;
        }
        
        /**
         * Описание исследования
         */
        public function get researchDesc():ResearchDescVO
        {
            return _researchDesc;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String, data:Object=null, out:GameEventCmdData=null):void
        {
            if (_researchEvent && eventId == _researchEvent)
            {
                // Событие, по которому происходит пересчет процента завершенности исследования
                
            }
            else
            {
                super.event(eventId, data, out);
            }
        }
        
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = researchId;
            res.@percent = researchPercent;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            researchId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            researchPercent = data.hasOwnProperty("@percent") ? Number(data.@percent) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	