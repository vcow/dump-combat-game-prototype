package proxy
{
	import dictionary.DefaultsDict;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.BaseVO;
	import vo.PriceVO;
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
		public function setResource(resourceId:uint, resourceCount:int):int
		{
			return 0;
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