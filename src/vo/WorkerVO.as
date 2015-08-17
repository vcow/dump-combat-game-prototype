package vo
{
    import dictionary.Const;
    
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object задействованного работника
	 * 
	 */
	
	public class WorkerVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "worker";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var workerPersonId:String;           // Идентификатор персонажа
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function WorkerVO()
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
			
			res.@person = workerPersonId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            workerPersonId = data.hasOwnProperty("@person") ? data.@person.toString() : Const.NO_GUID;
			
			// /TODO
			
			return true;
		}
	}
}