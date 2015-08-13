package vo
{
    import dictionary.Const;
    
    import facade.ProtoFacade;
    
    import proxy.PersonsProxy;

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
		
		private var _workerPersonId:String;
        private var _workerPerson:PersonVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function WorkerVO()
		{
			super(NAME);
		}
        
        /**
         * Идентификатор персонажа
         */
        public function set workerPersonId(value:String):void
        {
            if (value == _workerPersonId)
                return;
            
            _workerPersonId = value;
            _workerPerson = PersonsProxy(ProtoFacade.getInstance().retrieveProxy(PersonsProxy.NAME)).getPersonById(_workerPersonId);
        }
        
        public function get workerPersonId():String
        {
            return _workerPersonId;
        }
        
        /**
         * Описание персонажа
         */
        public function get workerPerson():PersonVO
        {
            return _workerPerson;
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