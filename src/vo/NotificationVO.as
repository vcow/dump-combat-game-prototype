package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object нотификации
	 * 
	 */
	
	public class NotificationVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "notification";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var notificationId:String;       //< Идентификатор нотификации
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function NotificationVO()
		{
			super(NAME);
		}
        
        public function get notificationCondition():Object
        {
            for each (var child:IVO in children)
            {
                if (child.name == ConditionVO.NAME)
                    return ConditionVO(child).conditionData;
            }
            return {};
        }
        
        public function get notificationData():Object
        {
            for each (var child:IVO in children)
            {
                if (child.name == DataVO.NAME)
                    return DataVO(child).dataValue;
            }
            return {};
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = notificationId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            notificationId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}