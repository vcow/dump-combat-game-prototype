package vo
{
    import mx.resources.ResourceManager;
    
    import command.data.GameEventCmdData;
    
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import helpers.ResourcesHelper;

    [ResourceBundle("messages")]
    
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
		
        public var moduleInactive:uint;             //< Количество ходов, которое модуль пребывает в неактивном состоянии
                                                    //< (если 0, модуль активен)
		public var moduleChance:Number;             //< Вероятность сохранения модуля после захвата базы
                                                    //< (если не NaN, переопределяет значение из словаря модулей ModuleDescVO)
		
		private var _moduleId:uint;                 //< Идентификатор модуля
		
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
		
        override public function event(eventId:String, out:GameEventCmdData=null):void
        {
            if (_feeEventId && eventId == _feeEventId)
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
                        
                        moduleInactive = 0;
					}
	                else
	                {
	                    // Отключить модуль за неуплату
                        moduleInactive += 1;
                        
                        var message:String = ResourceManager.getInstance().getString("messages", "disconnected.for.non.payment", [ moduleDesc.moduleName ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
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
            
            if (moduleInactive)
                res.@inactive = moduleInactive;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : NaN;
            moduleInactive = data.hasOwnProperty("@inactive") ? uint(data.@inactive) : 0;
			
			// /TODO
			
			return true;
		}
	}
}