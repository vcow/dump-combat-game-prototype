package helpers
{
	import dictionary.ModulesDict;
	import dictionary.ResourcesDict;
	
	import proxy.AppDataProxy;
	import proxy.BasesListProxy;
	
	import vo.BaseVO;
	import vo.BasesVO;
	import vo.ModuleDescVO;
	import vo.ModuleVO;
	import vo.ResourceDescVO;
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
		private var _appDataProxy:AppDataProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ModulesHelper(basesListProxy:BasesListProxy, appDataProxy:AppDataProxy)
		{
			_basesListProxy = basesListProxy;
			_appDataProxy = appDataProxy;
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
				bases = _basesListProxy.getBasesList();
			}
			
			var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(ModuleDescVO.STORE);
			for each (base in bases)
			{
				var modules:Vector.<ModuleVO> = base.getModules(moduleId);
				var space:int = modules.length * moduleDesc.moduleSpace;
				
				var store:StoreVO = base.baseStore;
				if (store)
				{
					for each (var resource:ResourceVO in store.children)
						space -= resource.resourceCount * ResourcesDict.getInstance().getResource(resource.resourceId).resourceSize;
				}
				
				res += space;
			}
			
			return res;
		}
	}
}