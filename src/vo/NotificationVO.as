package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object ресурса
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
        public var notificationChance:Number;   //< Вероятность срабатывания нотификации
        public var notificationData:Object;     //< Данные нотификации
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function NotificationVO()
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
			
			res.@id = notificationId;
			res.@chance = notificationChance;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
			
            notificationId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            notificationChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : 1.0;
            
            notificationData = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}