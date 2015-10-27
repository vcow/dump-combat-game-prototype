package vo
{
    import dictionary.Const;

    [ResourceBundle("quests")]
    
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object сообщения для юзера
	 * 
	 */
	
	public class UiMessageVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "uiMessage";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var uiMessageText:String;                    //< Текст сообщения
        public var uiMessageButtons:uint;                   //< Набор кнопок
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function UiMessageVO()
		{
			super(NAME);
		}
        
        public function get uiMessageOkHandler():OkVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == OkVO.NAME)
                    return item as OkVO;
            }
            return null;
        }
        
        public function get uiMessageCancelHandler():CancelVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == CancelVO.NAME)
                    return item as CancelVO;
            }
            return null;
        }
        
        public function get uiMessageYesHandler():YesVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == YesVO.NAME)
                    return item as YesVO;
            }
            return null;
        }
        
        public function get uiMessageNoHandler():NoVO
        {
            for each (var item:IVO in children)
            {
                if (item.name == NoVO.NAME)
                    return item as NoVO;
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
			
			res.@text = uiMessageText;
            
            var buttons:String = "";
            if (uiMessageButtons & Const.CANCEL) buttons = "cancel";
            if (uiMessageButtons & Const.OK) buttons += buttons ? ",ok" : "ok";
            if (uiMessageButtons & Const.YES) buttons += buttons ? ",yes" : "yes";
            if (uiMessageButtons & Const.NO) buttons += buttons ? ",no" : "no";
            
            res.@buttons = buttons;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            uiMessageText = data.hasOwnProperty("@text") ? VO.parseString(data.@text, "quests") : Const.NO_TEXT;
            
            var buttons:Array = data.hasOwnProperty("@buttons") ? data.@buttons.toString().split(",") : [ "ok" ];
            uiMessageButtons = 0;
            for each (var btn:String in buttons)
            {
                switch (btn.toLowerCase())
                {
                    case "cancel": uiMessageButtons |= Const.CANCEL; break;
                    case "ok": uiMessageButtons |= Const.OK; break;
                    case "yes": uiMessageButtons |= Const.YES; break;
                    case "no": uiMessageButtons |= Const.NO; break;
                }
            }
			
			// /TODO
			
			return true;
		}
	}
}