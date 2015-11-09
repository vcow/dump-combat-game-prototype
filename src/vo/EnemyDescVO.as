package vo
{
    import dictionary.Const;
    
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object описания врага
	 * 
	 */
	
	public class EnemyDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "enemyDesc";
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var enemyId:String;				//< Идентификатор врага
		public var enemyName:String;            //< Имя врага
        public var enemyDescription:String;     //< Описание врага
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function EnemyDescVO()
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
			
			res.@id = enemyId;
            res.@name = enemyName;
            res.@description = enemyDescription;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            enemyId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            enemyName = data.hasOwnProperty("@name") ? data.@name.toString() : Const.NO_TEXT;
            enemyDescription = data.hasOwnProperty("@description") ? data.@description.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}