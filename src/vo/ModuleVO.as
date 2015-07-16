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
        public var moduleIndex:uint;                //< Уникальный индекс модуля (служит для идентификации модуля в рамках базы)
        public var moduleBuildTimer:String;         //< Идентификатор таймера постройки (если есть, здание строится)
		
		private var _moduleId:uint;                 //< Идентификатор модуля
		
		private var _moduleDesc:ModuleDescVO;
        private var _feeEventId:String;
        private var _builtEventId:String;
        
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
            
            var leadTime:LeadTimeVO = _moduleDesc.moduleLeadTime;
            _builtEventId = leadTime ? leadTime.leadTimeEvent : "";
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
		
        override public function event(eventId:String, data:Object=null, out:GameEventCmdData=null):void
        {
            if (_feeEventId && eventId == _feeEventId)
            {
                // Событие, по которому взымается плата за эксплуатацию модуля
                if (out)
				{
					var outData:Array = out.commonOut[Const.CHANGE_RESOURCES] as Array;
					var resourcesDecor:ResourcesHelper = new ResourcesHelper();
					
					var commonFee:PriceVO;
                    if (outData)
						commonFee = resourcesDecor.joinPrice(resourcesDecor.joinPrice.apply(this, outData),
                            resourcesDecor.invertPrice(moduleDesc.moduleFee));
					else
						commonFee = resourcesDecor.invertPrice(moduleDesc.moduleFee);
					
					if (resourcesDecor.isEnoughResources(resourcesDecor.separatePrice(commonFee, true)[1]))
					{
						out.commonOut[Const.CHANGE_RESOURCES] = [ commonFee ];
                        
                        if (moduleInactive > 0)
                        {
                            moduleInactive = 0;
                            out.privateOut[Const.MODULES_CHANGED] = [];
                        }
					}
	                else
	                {
	                    // Отключить модуль за неуплату
                        if (moduleInactive == 0)
                            out.privateOut[Const.MODULES_CHANGED] = [];
                        
                        moduleInactive += 1;
                        
                        var message:String = ResourceManager.getInstance().getString("messages", "disconnected.for.non.payment", [ moduleDesc.moduleName ]);
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
                    out.privateOut[Const.MODULES_CHANGED] = [];
                }
                else
                {
                    super.event(eventId, data, out);
                }
            }
            else
            {
                super.event(eventId, data, out);
            }
        }
        
		override public function clone():VO
		{
			var res:ModuleVO = new ModuleVO();
			res.moduleId = moduleId;
            res.moduleIndex = moduleIndex;
			
			return res;
		}
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = moduleId;
            res.@index = moduleIndex;
            
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
			
			moduleId = data.hasOwnProperty("@id") ? uint(data.@id) : 0;
			moduleChance = data.hasOwnProperty("@chance") ? Number(data.@chance) : NaN;
            moduleInactive = data.hasOwnProperty("@inactive") ? uint(data.@inactive) : 0;
            moduleIndex = data.hasOwnProperty("@index") ? uint(data.@index) : 0;
            moduleBuildTimer = data.hasOwnProperty("@buildTimer") ? data.@buildTimer.toString() : "";
			
			// /TODO
			
			return true;
		}
	}
}