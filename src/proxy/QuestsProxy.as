package proxy
{
	import dictionary.Const;
	import dictionary.DefaultsDict;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.QuestVO;
	import vo.QuestsVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Прокси текущего квеста
	 * 
	 */
	
	public class QuestsProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "questProxy";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function QuestsProxy(data:QuestsVO=null)
		{
			super(NAME, data);
		}
		
		public function get questsVO():QuestsVO
		{
			return getData() as QuestsVO;
		}
        
        /**
         * Получить активный квест по его идентификатору
         * @param questId идентификатор квеста
         * @return активный квест
         */
        public function getQuest(questId:String):QuestVO
        {
            for each (var quest:QuestVO in questsVO.children)
            {
                if (quest.questId == questId)
                    return quest;
            }
            return null;
        }
        
        /**
         * Запустить на выполнение квест
         * @param questId
         */
        public function startQuest(questId:String):void
        {
            if (getQuest(questId))
                return;         // Такой квест уже запущен
            
            var quest:QuestVO = new QuestVO();
            quest.questId = questId;
            quest.questStep = 0;
            
            if (!quest.questDecs)
                throw Error("There is no quest " + questId + ".");
            
            questsVO.children.push(quest);
            
            sendNotification(Const.QUEST_STARTED, quest.questId);
        }
		
		//----------------------------------
		//  Proxy
		//----------------------------------
		
        override public function onRegister():void
        {
			if (!data)
			{
				var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
				var value:QuestsVO = appDataProxy.getChildByName(QuestsVO.NAME) as QuestsVO;
				
				if (!value)
                {
					value = new QuestsVO();
                    setData(value);
                    appDataProxy.updateChild(questsVO);
                    
                    startQuest(DefaultsDict.getInstance().startQuestId);
                }
                else
                {
				    setData(value);
                }
			}
		}
	}
}