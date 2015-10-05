package vo
{
    import mx.resources.ResourceManager;
    
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import helpers.ModulesHelper;
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
        public var moduleId:String;                 //< Уникальный идентификатор модуля
        public var moduleBuildTimer:String;         //< Идентификатор таймера постройки (если есть, здание строится)
		
		private var _moduleModuleId:String;         //< Идентификатор описания модуля
		
		private var _moduleDesc:ModuleDescVO;
        private var _feeEventId:String;
        private var _builtEventId:String;
        
        private var _fee:PriceVO;
        private var _invFee:PriceVO;
        
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModuleVO()
		{
			super(NAME);
		}
        
        public function set moduleModuleId(value:String):void
        {
            if (value == _moduleModuleId)
                return;
            
            _moduleModuleId = value;
            
			_moduleDesc = ModulesDict.getInstance().getModule(_moduleModuleId);
            
            var fee:PriceVO = _moduleDesc.moduleFee;
            _feeEventId = fee ? fee.priceEventId : "";
            
            var leadTime:LeadTimeVO = _moduleDesc.moduleLeadTime;
            _builtEventId = leadTime ? leadTime.leadTimeEvent : "";
        }
        
        public function get moduleModuleId():String
        {
            return _moduleModuleId;
        }
		
		public function get moduleDesc():ModuleDescVO
		{
			return _moduleDesc;
		}
        
        private function get invFee():PriceVO
        {
            if (!_invFee)
                _invFee = (new ResourcesHelper()).invertPrice(moduleDesc.moduleFee);
            return _invFee;
        }
        
        private function get fee():PriceVO
        {
            if (!_fee)
                _fee = (new ResourcesHelper()).separatePrice(invFee, true)[1];
            return _fee;
        }
        
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String, data:Object=null):void
        {
            if (_feeEventId && eventId == _feeEventId)
            {
                // Событие, по которому взымается плата за эксплуатацию модуля
				var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                if (resourcesDecor.isEnoughResources(fee))
                {
                    sendNotification(Const.CHANGE_RESOURCES, invFee);
                    
                    if (moduleInactive > 0)
                    {
                        moduleInactive = 0;
                        sendNotification(Const.MODULES_CHANGED, (new ModulesHelper()).getModulePlace(moduleId));
                        
                        var message:String = ResourceManager.getInstance().getString("messages", "module.resumed", [ moduleDesc.moduleName ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.MESSAGE);
                    }
                }
                else
                {
                    // Отключить модуль за неуплату
                    
                    var moduleWasActive:Boolean = moduleInactive == 0;
                    moduleInactive += 1;
                    
                    if (moduleWasActive)
                    {
                        sendNotification(Const.MODULES_CHANGED, (new ModulesHelper()).getModulePlace(moduleId));
                        
                        message = ResourceManager.getInstance().getString("messages", "disconnected.for.non.payment", [ moduleDesc.moduleName ]);
                        sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                    }
                }
            }
            else if (moduleBuildTimer && _builtEventId && eventId == _builtEventId)
            {
                var timerId:String = data ? data.toString() : "";
                if (moduleBuildTimer == timerId)
                {
                    // Сработал таймер окончания постройки этого модуля
                    moduleBuildTimer = "";
                    sendNotification(Const.MODULES_CHANGED, (new ModulesHelper()).getModulePlace(moduleId));
                }
                else
                {
                    super.event(eventId, data);
                }
            }
            else
            {
                super.event(eventId, data);
            }
        }
        
		override public function clone():VO
		{
			var res:ModuleVO = new ModuleVO();
			res.moduleModuleId = moduleModuleId;
            res.moduleId = moduleId;
			
			return res;
		}
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@moduleId = moduleModuleId;
            res.@id = moduleId;
            
            if (moduleInactive)
                res.@inactive = moduleInactive;
            
            if (moduleBuildTimer)
                res.@buildTimer = moduleBuildTimer;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
			moduleModuleId = data.hasOwnProperty("@moduleId") ? data.@moduleId.toString() : "";
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : NaN;
            moduleInactive = data.hasOwnProperty("@inactive") ? uint(data.@inactive) : 0;
            moduleId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            moduleBuildTimer = data.hasOwnProperty("@buildTimer") ? data.@buildTimer.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}