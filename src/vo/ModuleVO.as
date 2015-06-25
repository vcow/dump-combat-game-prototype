package vo
{
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import helpers.ResourcesHelper;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object модуля
	 * 
	 */
	
	public class ModuleVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "module";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public var moduleChance:Number;			//< Вероятность сохранения модуля после захвата базы
												//< (если не NaN, переопределяет значение из словаря модулей ModuleDescVO)
		
		private var _moduleId:uint;				//< Идентификатор модуля
        private var _feeEventId:String;
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModuleVO()
		{
			super(NAME);
		}
        
        public function set moduleId(value:uint):void
        {
            if (value == _moduleId)
                return;
            
            _moduleId = value;
            
            var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(_moduleId);
            var fee:PriceVO = moduleDesc ? moduleDesc.moduleFee : null;
            _feeEventId = fee ? fee.priceEventId : "";
        }
        
        public function get moduleId():uint
        {
            return _moduleId;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String, out:Object=null):void
        {
            if (eventId == _feeEventId)
            {
                // Событие, по которому взымается плата за эксплуатацию модуля
                var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(_moduleId);
                if ((new ResourcesHelper()).pay(moduleDesc.moduleFee, false))
                {
                    // Произведен платежь за эксплуатацию модуля
                    if (out)
                        out[Const.RESOURCES_CHANGED] = null;
                }
                else
                {
                    // Отключить модуль за неуплату
                    
                }
            }
            else
            {
                super.event(eventId, out);
            }
        }
        
		override public function clone():VO
		{
			var res:ModuleVO = new ModuleVO();
			res.moduleId = moduleId;
			
			return res;
		}
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = moduleId;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : NaN;
			
			// /TODO
			
			return true;
		}
	}
}