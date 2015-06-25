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
		
		public function ApplicationVO(parent:IVO=null)
		{
			super(NAME, parent);
		}
        
        /**
         * Сериализуемый объект для хранения текущих внутриигровых состояний
         */
        public function get stuff():Object
        {
            if (!_stuff)
            {
                var item:StuffVO;
                for (var i:int = 0; i < numChildren; i++)
                {
                    var value:IVO = getChildAt(i);
                    if (value.name == StuffVO.NAME)
                    {
                        item = value as StuffVO;
                        break;
                    }
                }
                
                if (!item)
                {
                    item = new StuffVO();
                    addChild(item);
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