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
                
				var now:Number = (new Date()).time;
                if (!item)
                {
                    item = new StuffVO();
                    children.push(item);
				}
				
				if (item.data.hasOwnProperty("timestamp"))
				{
					item.data.exitTime = item.data.timestamp;					//< Время завершения предыдущей сессии
                }
				else
				{
					item.data.beginingOfTime = now;								//< Время начала игры
					item.data.timestamp = now;									//< Текущая временная метка
				}
				item.data.restoreTime = now;									//< Время возобновления игры
                
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