package vo
{
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import helpers.ResourcesHelper;
    
    import managers.EventOut;

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
		
		private var _moduleDesc:ModuleDescVO;
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
            
			_moduleDesc = ModulesDict.getInstance().getModule(_moduleId);
            var fee:PriceVO = _moduleDesc.moduleFee;
            _feeEventId = fee ? fee.priceEventId : "";
        }
        
        public function get moduleId():uint
        {
            return _moduleId;
        }
		
		public function get moduleDesc():ModuleDescVO
		{
			return _moduleDesc;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String, out:EventOut=null):void
        {
            if (eventId == _feeEventId)
            {
                // Событие, по которому взымается плата за эксплуатацию модуля
                if (out)
				{
					var data:Array = out.commonOut[Const.CHANGE_RESOURCES] as Array;
					var resourcesDecor:ResourcesHelper = new ResourcesHelper();
					
					var commonFee:PriceVO;
                    if (data)
						commonFee = resourcesDecor.joinPrice(resourcesDecor.joinPrice.apply(this, data), resourcesDecor.invertPrice(moduleDesc.moduleFee));
					else
						commonFee = resourcesDecor.invertPrice(moduleDesc.moduleFee);
					
					if (resourcesDecor.isEnoughResources(resourcesDecor.separatePrice(commonFee, true)[1]))
					{
						out.commonOut[Const.CHANGE_RESOURCES] = [ commonFee ];
					}
	                else
	                {
	                    // Отключить модуль за неуплату
	                }
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