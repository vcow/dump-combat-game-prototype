package helpers
{
	import dictionary.ModulesDict;
	
	import facade.ProtoFacade;
	
	import proxy.BasesListProxy;
	import proxy.InvestigationsProxy;
	import proxy.ProductionsProxy;
	
	import vo.BaseVO;
	import vo.ModuleDescVO;
	import vo.ModuleVO;
	import vo.PersonnelVO;
	import vo.ResourceVO;
	import vo.StoreVO;

	/**
	 * 
	 * @author jvirkovskiy
	 * Декоратор модулей
	 * 
	 */
	
	public class ModulesHelper
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		private var _basesListProxy:BasesListProxy;
        private var _investigationsProxy:InvestigationsProxy;
        private var _productionsProxy:ProductionsProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModulesHelper(basesListProxy:BasesListProxy=null, investigationsProxy:InvestigationsProxy=null,
                                      productionsProxy:ProductionsProxy=null)
		{
			_basesListProxy = basesListProxy;
            _investigationsProxy = investigationsProxy;
            _productionsProxy = productionsProxy;
		}
		
		/**
		 * Получить незанятое пространство в модулях указанного типа
		 * @param moduleId идентификатор модуля
		 * @param base база, для которой определяется загрузка модуля, если null, загрузка определяется для всех баз
         * @param includeInactive включать в результат некативные модули
		 * @return незанятое пространство (может быть отрицательным, если модули переполнены)
		 */
		public function getSpace(moduleId:String, base:BaseVO=null, includeInactive:Boolean=false):int
		{
			var res:int = 0;
			
			var bases:Vector.<BaseVO>;
			if (base)
			{
				bases = new Vector.<BaseVO>(1, true);
				bases[0] = base;
			}
			else
			{
				bases = basesListProxy.getBasesList();
			}
			
			var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(ModuleDescVO.STORE);
			for each (base in bases)
			{
				var modules:Vector.<ModuleVO> = base.getModules(moduleId, includeInactive);
				var space:int = modules.length * moduleDesc.moduleSpace;
				
                switch (moduleId)
                {
                    case ModuleDescVO.STORE:
                        var store:StoreVO = base.baseStore;
                        if (store)
                        {
                            for each (var resource:ResourceVO in store.children)
                                space -= resource.resourceCount * resource.resourceDesc.resourceSize;
                        }
                        break;
                    case ModuleDescVO.HOUSING:
                        var personnel:PersonnelVO = base.basePersonnel;
                        space -= personnel ? base.basePersonnel.children.length : 0;
                        break;
                    case ModuleDescVO.LAB:
                        space -= investigationsProxy.getEmployedScientists(null, base.baseId).length;
                        break;
                    case ModuleDescVO.WORKSHOP:
                        space -= productionsProxy.getEmployedEngineers(null, base.baseId).length;
                        break;
                }
				
				res += space;
			}
			
			return res;
		}
        
        /**
         * Получить базу, которой принадлежит указанный модуль
         * @param moduleId идентификатор модуля
         * @return база
         */
        public function getModulePlace(moduleId:String):BaseVO
        {
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                for each (var module:ModuleVO in base.baseModules.children)
                {
                    if (module.moduleId == moduleId)
                        return base;
                }
            }
            return null;
        }
        
        /**
         * Получить модуль по его идентификатору
         * @param moduleId идентификатор модуля
         * @return модуль
         */
        public function getModule(moduleId:String):ModuleVO
        {
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                for each (var module:ModuleVO in base.baseModules.children)
                {
                    if (module.moduleId == moduleId)
                        return module;
                }
            }
            return null;
        }
        
        /**
         * Получить количество модулей указанного типа для указанной базы
         * @param moduleId идентификатор типа модулей, если 0, считаются все модули
         * @param baseId идентификатор базы, если null, считаются все базы
         * @return количество модулей
         */
        public function getModulesCount(moduleId:String=null, baseId:String=null):int
        {
            var ctr:int = 0;
            for each (var base:BaseVO in basesListProxy.getBasesList())
            {
                if (baseId)
                {
                    if (base.baseId == baseId)
                    {
                        for each (var module:ModuleVO in base.baseModules.children)
                        {
                            if (!moduleId || module.moduleModuleId == moduleId)
                                ctr++;
                        }
                        break;
                    }
                }
                else
                {
                    for each (module in base.baseModules.children)
                    {
                        if (!moduleId || module.moduleModuleId == moduleId)
                            ctr++;
                    }
                }
            }
            return ctr;
        }
		
		private function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
				_basesListProxy = BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
			return _basesListProxy;
		}
        
        private function get investigationsProxy():InvestigationsProxy
        {
            if (!_investigationsProxy)
                _investigationsProxy = InvestigationsProxy(ProtoFacade.getInstance().retrieveProxy(InvestigationsProxy.NAME));
            return _investigationsProxy;
        }
        
        private function get productionsProxy():ProductionsProxy
        {
            if (!_productionsProxy)
                _productionsProxy = ProductionsProxy(ProtoFacade.getInstance().retrieveProxy(ProductionsProxy.NAME));
            return _productionsProxy;
        }
	}
}