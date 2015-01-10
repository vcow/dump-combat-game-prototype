package proxy
{
	import dictionary.DefaultsDict;
	import dictionary.ModulesDict;
	import dictionary.ResourcesDict;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.BaseVO;
	import vo.ModuleDescVO;
	import vo.ModuleVO;
	import vo.PriceVO;
	import vo.ResourceDescVO;
	import vo.ResourceVO;
	import vo.StoreVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Прокси игровх ресурсов
	 * 
	 */
	
	public class ResourcesListProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "resourcesProxy";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourcesListProxy()
		{
			super(NAME);
		}
		
		/**
		 * Узнать, хватает ли ресурсов на оплату
		 * @param priceVO цена
		 * @return true, если ресурсов хватает
		 */
		public function isEnoughResources(price:PriceVO):Boolean
		{
			var store:StoreVO = getAllResources() || getAllResources(true);
			
			for each (var requiredRes:ResourceVO in price.children)
			{
				var resourceNotFound:Boolean = true;
				for each (var availableRes:ResourceVO in store.children)
				{
					if (availableRes.resourceId == requiredRes.resourceId)
					{
						if (availableRes.resourceCount < requiredRes.resourceCount)
							return false;
						
						resourceNotFound = false;
						break;
					}
				}
				
				if (resourceNotFound)
					return false;
			}
			
			return true;
		}
		
		/**
		 * Заплатить указанную цену
		 * @param priceVO цена
		 * @return true, если платеж выполнен успешно, false, если какой-то из ресурсов ушел в минус
		 */
		public function pay(price:PriceVO):Boolean
		{
			var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
			var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
			
			if (bases.length == 0 || !isEnoughResources(price))
				return false;	// Платеж производится только из складов при наличии достаточного количества ресурсов
			
			for each (var requiredRes:ResourceVO in price.children)
			{
				var paid:Boolean = false;
				var count:int = requiredRes.resourceCount;
				
				if (count == 0)
					continue;
				
				for each (var base:BaseVO in bases)
				{
					var store:StoreVO = base.baseStore;
					for each (var availableRes:ResourceVO in store.children)
					{
						if (availableRes.resourceId == requiredRes.resourceId)
						{
							var rest:int = availableRes.resourceCount - count;
							if (rest < 0)
							{
								// На этой базе ресурс исчерпан, требуется еще
								count = -rest;
								availableRes.resourceCount = 0;
							}
							else
							{
								// По этому ресурсу расчитались
								count = 0;
								availableRes.resourceCount = rest;
								paid = true;
							}
							break;
						}
					}
					
					if (paid)
						break;
				}
				
				if (!paid)
					throw Error("Not enough resources.");
			}
			
			var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
			appDataProxy.saveData();
			
			return true;
		}
		
		/**
		 * Получить количество указанного ресурса
		 * @param resourceId идентификатор ресурса
		 * @return количество ресурса
		 */
		public function getResource(resourceId:uint):int
		{
			var store:StoreVO = getAllResources() || getAllResources(true);
			for each (var value:ResourceVO in store.children)
			{
				if (value.resourceId == resourceId)
					return value.resourceCount;
			}
			return 0;
		}
		
		/**
		 * Задать новое количество указанного ресурса
		 * @param resourceId идентификатор ресурса
		 * @param resourceCount новое количество ресурса
		 * @return количество ресурса, размещенное на складах (будет меньше, если складов не хватает)
		 */
		public function addResource(resourceId:uint, resourceCount:int):int
		{
			var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(ModuleDescVO.STORE);
			var resourceDesc:ResourceDescVO = ResourcesDict.getInstance().getResource(resourceId);
			
			if (!moduleDesc || !resourceDesc || resourceCount <= 0)
				return 0;
			
			var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
			var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
			var rest:int = resourceCount;
			
			for each (var base:BaseVO in bases)
			{
				if (resourceDesc.resourceSize == 0)
				{
					// Ресурс с бесконечной вместимостью (например, деньги)
					// пихаем в первую попавшуюся базу
					addResourceToBase(base, resourceId, resourceCount);
					rest = 0;
					break;
				}
				else
				{
					// Прошерстить все складские модули в поисках нужного пространства
					var freeSpace:int = 0;
					var storeModules:Vector.<ModuleVO> = base.getModules(ModuleDescVO.STORE);
					for each (var module:ModuleVO in storeModules)
						freeSpace += moduleDesc.moduleSpace - module.moduleFilled;
					
					// сколко единиц ресурса поместится в найденное свободное пространство
					freeSpace = freeSpace / resourceDesc.resourceSize;
					
					if (freeSpace == 0)
						continue;	// Для этого ресурса места нет
					
					var filled:int;	// Место, которое будет занято ресурсом на складах
					if (rest > freeSpace)
					{
						filled = freeSpace * resourceDesc.resourceSize;
						rest -= freeSpace;
					}
					else
					{
						filled = rest * resourceDesc.resourceSize;
						rest = 0;
					}
					
					// Раскидать загрузку по складским модулям
					for each (module in storeModules)
					{
						freeSpace = moduleDesc.moduleSpace - module.moduleFilled;
						if (filled > freeSpace)
						{
							module.moduleFilled = moduleDesc.moduleSpace;
							filled -= freeSpace;
						}
						else
						{
							module.moduleFilled += filled;
							filled = 0;
						}
						
						if (filled == 0)
							break;
					}
					
					addResourceToBase(base, resourceId, resourceCount - rest);
				}
				
				if (rest == 0)
					break;
			}
			
			var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
			appDataProxy.saveData();
			
			return resourceCount - rest;
		}
		
		/**
		 * Вспомогательная функция, добавляет ресурс в список ресурсов, использовать
		 * только из addResource, чтобы не нарушать расчет заполнения модулей
		 * @param base база, в которую добавляется ресурс
		 * @param resourceId идентификатор добавляемого ресурса
		 * @param count количество добавляемого ресурса
		 */
		private function addResourceToBase(base:BaseVO, resourceId:uint, count:int):void
		{
			// Добавить ресурс
			var resourceAdded:Boolean = false;
			var store:StoreVO = base.baseStore;
			for each (var resource:ResourceVO in store.children)
			{
				if (resource.resourceId == resourceId)
				{
					resource.resourceCount += count;
					resourceAdded = true;
					break;
				}
			}
			
			if (!resourceAdded)
			{
				resource = new ResourceVO();
				resource.resourceId = resourceId;
				resource.resourceCount = count;
				
				store.children.push(resource);
			}
		}
		
		/**
		 * Получить список всех доступных ресурсов
		 * @param getDefaults возвратить список ресурсов по умолчанию 
		 * @return список всех доступных ресурсов
		 */
		private function getAllResources(getDefaults:Boolean=false):StoreVO
		{
			var store:StoreVO;
			
			if (getDefaults)
			{
				store = new StoreVO();
				store.append(DefaultsDict.getInstance().resourcesList);
			}
			else
			{
				var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
				var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
				if (bases.length > 0)
				{
					store = new StoreVO();
					for each (var base:BaseVO in bases)
						store.append(base.baseStore);
				}
			}
			
			return store;
		}
		
		//----------------------------------
		//  Proxy
		//----------------------------------
		
	}
}