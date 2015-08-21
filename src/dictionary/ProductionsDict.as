package dictionary
{
	import facade.ProtoFacade;
	
	import helpers.ConditionHelper;
	
	import proxy.TriggersProxy;
	
	import vo.ProductionDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека производств
	 * 
	 */
	
	public final class ProductionsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/production.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:ProductionsDict;
		private static var _productions:Vector.<ProductionDescVO>;
        
        private var _triggersProxy:TriggersProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function ProductionsDict()
        {
            if (_instance != null)
                throw Error("ProductionDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():ProductionsDict
		{
			if (!_instance)
				_instance = new ProductionsDict();
			return _instance;
		}
        
        /**
         * Получить описание производства по его идентификатору
         * @param researchId идентификатор производства
         * @return описание производства
         */
        public function getProduction(productionId:String):ProductionDescVO
        {
            init();
            
            for each (var production:ProductionDescVO in _productions)
            {
                if (production.productionId == productionId)
                    return production;
            }
            return null;
        }
        
        /**
         * Получить список доступных производств
         * @return список доступных производств
         */
        public function getAvailableProductions():Vector.<ProductionDescVO>
        {
            init();
            
            var conditionDecor:ConditionHelper = new ConditionHelper(triggersProxy);
            var prod:Vector.<ProductionDescVO> = new Vector.<ProductionDescVO>();
            
            for each (var production:ProductionDescVO in _productions)
            {
                if (conditionDecor.parseCondition(production.productionCondition))
                    prod.push(production);
            }
            
            return prod;
        }
        
        protected function get triggersProxy():TriggersProxy
        {
            if (!_triggersProxy)
                _triggersProxy = TriggersProxy(ProtoFacade.getInstance().retrieveProxy(TriggersProxy.NAME));
            return _triggersProxy;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function init():void
        {
            if (!_productions)
            {
                _productions = new Vector.<ProductionDescVO>();
                
                var src:XML = XML(new source());
                for each (var item:XML in src.children())
                {
                    var production:ProductionDescVO = new ProductionDescVO();
                    production.deserialize(item);
                    _productions.push(production);
                }
            }
        }
	}
}