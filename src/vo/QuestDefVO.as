package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object описания квеста
	 * 
	 */
	
	public class QuestDefVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "questDef";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var questDefId:String;           //< Идентификатор квеста по умолчанию
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
		public function QuestDefVO()
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
            
            res.@id = questDefId;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            questDefId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            
            // /TODO
            
            return true;
        }
	}
}