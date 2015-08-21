package vo
{
    import mx.resources.ResourceManager;
    
    import command.data.GameEventCmdData;
    
    import dictionary.Const;
    import dictionary.ProductionsDict;
    
    import facade.ProtoFacade;
    
    import helpers.ResourcesHelper;
    import helpers.ResultHelper;
    
    import proxy.ProductionsProxy;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object активного производства
	 * 
	 */
	
	public class ProductionVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "production";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var productionPercent:Number = 0;            //< Процент завершения производства единицы продукции (значение от 0 до 1.0)
        public var productionRest:int;                      //< Количество продукции, которую осталось произвести
        
		private var _productionId:String;
        private var _productionDesc:ProductionDescVO;
        private var _productionEvent:String;
        
        private var _productionsProxy:ProductionsProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ProductionVO()
		{
			super(NAME);
		}
        
        /**
         * Уникальный идентификатор исследования
         */
        public function set productionId(value:String):void
        {
            if (value == _productionId)
                return;
            
            _productionId = value;
            _productionDesc = ProductionsDict.getInstance().getProduction(_productionId);
            _productionEvent = _productionDesc ? _productionDesc.productionEventId : "";
        }
        
        public function get productionId():String
        {
            return _productionId;
        }
        
        /**
         * Описание исследования
         */
        public function get productionDesc():ProductionDescVO
        {
            return _productionDesc;
        }
        
        private function get productionsProxy():ProductionsProxy
        {
            if (!_productionsProxy)
                _productionsProxy = ProductionsProxy(ProtoFacade.getInstance().retrieveProxy(ProductionsProxy.NAME));
            return _productionsProxy;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
        override public function event(eventId:String, data:Object=null, out:GameEventCmdData=null):void
        {
            if (_productionEvent && eventId == _productionEvent)
            {
                // Событие, по которому происходит пересчет процента завершения производства единицы продукции
                
                if (out)
                {
                    if (productionDesc.productionPrice > 0)
                    {
                        var numEmployedEngineers:Number = productionsProxy.getEmployedEngineers(productionId).children.length;
                        var delta:Number = numEmployedEngineers / Number(productionDesc.productionPrice);
                        productionPercent += delta;
                    }
                    else
                    {
                        productionPercent = 1.0;
                    }
                    
                    if (productionPercent >= 1.0)
                    {
                        if (productionRest > 0)
                        {
                            // Завершено изготовление единицы продукции
                            var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                            var result:PriceVO = (new ResultHelper(null, resourcesDecor)).applyResult(productionDesc.productionResult, true) || new PriceVO();
                            
                            var outData:Array = out.commonOut[Const.CHANGE_RESOURCES] as Array;
                            var commonPrice:PriceVO;
                            if (outData)
                                commonPrice = resourcesDecor.joinPrice(resourcesDecor.joinPrice.apply(this, outData), result);
                            else
                                commonPrice = result;
                            out.commonOut[Const.CHANGE_RESOURCES] = [ commonPrice ];
                            
                            productionRest--;
                            
                            if (productionRest > 0)
                            {
                                // Запустить в производство очередную единицу продукции
                                commonPrice = resourcesDecor.joinPrice(commonPrice, resourcesDecor.invertPrice(productionDesc.productionStartPrice));
                                
                                if (resourcesDecor.isEnoughResources(resourcesDecor.separatePrice(commonPrice, true)[1]))
                                {
                                    productionPercent = 0;
                                    out.commonOut[Const.CHANGE_RESOURCES] = [ commonPrice ];
                                }
                                else
                                {
                                    // Не хватает ресурсов для производства
                                    var message:String = ResourceManager.getInstance().getString("messages", "terminate.production", [ productionDesc.productionName ]);
                                    sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                                    
                                    productionRest = 0;
                                }
                            }
                        }
                        
                        if (productionRest <= 0)
                        {
                            // Производство завершено
                            outData = out.commonOut[Const.COMPLETE_PRODUCTION] as Array;
                            if (!outData)
                                out.commonOut[Const.COMPLETE_PRODUCTION] = outData = [];
                            outData.push(productionId);
                        }
                    }
                }
            }
            else
            {
                super.event(eventId, data, out);
            }
        }
        
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
			res.@id = productionId;
            res.@percent = productionPercent;
            res.@rest = productionRest;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            productionId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            productionPercent = data.hasOwnProperty("@percent") ? Number(data.@percent) : 0;
            productionRest = data.hasOwnProperty("@rest") ? Number(data.@rest) : 0;
			
			// /TODO
			
			return true;
		}
	}
}
	