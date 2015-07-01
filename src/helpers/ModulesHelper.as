package helpers
{
	import dictionary.ModulesDict;
	
	import facade.ProtoFacade;
	
	import proxy.BasesListProxy;
	
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
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModulesHelper(basesListProxy:BasesListProxy=null)
		{
			_basesListProxy = basesListProxy;
		}
		
		/**
		 * Получить незанятое пространство в модулях указанного типа
		 * @param moduleId идентификатор модуля
		 * @param base база, для которой определяется загрузка модуля, если null, загрузка определяется для всех баз
		 * @return незанятое пространство (может быть отрицательным, если модули переполнены)
		 */
		public function getSpace(moduleId:uint, base:BaseVO=null):int
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
				var modules:Vector.<ModuleVO> = base.getModules(moduleId);
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
                        space -= personnel.children.length;
                        break;
                }
				
				res += space;
			}
			
			return res;
		}
		
		private function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
				_basesListProxy = BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
			return _basesListProxy;
		}
	}
}