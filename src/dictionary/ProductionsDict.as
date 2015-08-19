package dictionary
{
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