package vo
{
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object приложения
	 * 
	 */
	
	public class ApplicationVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "app";
        
        private var _stuff:Object;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ApplicationVO()
		{
			super(NAME);
		}
        
        /**
         * Сериализуемый объект для хранения текущих внутриигровых состояний
         */
        public function get stuff():Object
        {
            if (!_stuff)
            {
                var item:StuffVO;
                for each (var value:IVO in children)
                {
                    if (value.name == StuffVO.NAME)
                    {
                        item = value as StuffVO;
                        break;
                    }
                }
                
                if (!item)
                {
                    item = new StuffVO();
                    children.push(item);
                }
                
                _stuff = item.data;
            }
            return _stuff;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			return true;
		}
	}
}