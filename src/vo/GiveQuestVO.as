package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object выдачи квеста
	 * 
	 */
	
	public class GiveQuestVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "giveQuest";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var giveQuestId:String;              //< Идентификатор выдаваемого квеста
        public var giveQuestAsSubquest:Boolean;     //< Выдать квест как подквест (выдавающий квест будет ждать завершения выданного квеста)
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
		public function GiveQuestVO()
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
            
            res.@id = giveQuestId;
            
            if (giveQuestAsSubquest)
                res.@asSubquest = giveQuestAsSubquest;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            giveQuestId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            giveQuestAsSubquest = data.hasOwnProperty("@asSubquest") ? data.@asSubquest.toString().toLowerCase() == "true" : false;
            
            // /TODO
            
            return true;
        }
	}
}