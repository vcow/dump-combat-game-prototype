package helpers
{
	import dictionary.Const;
	import dictionary.DefaultsDict;
	import dictionary.ModulesDict;
	import dictionary.ResourcesDict;
	
	import facade.ProtoFacade;
	
	import proxy.AppDataProxy;
	import proxy.BasesListProxy;
	
	import vo.BaseVO;
	import vo.ModuleDescVO;
	import vo.PriceVO;
	import vo.ResourceDescVO;
	import vo.ResourceVO;
	import vo.StoreVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Декоратор игровх ресурсов
	 * 
	 */
	
	public class ResourcesHelper
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		private var _basesListProxy:BasesListProxy;
		private var _appDataProxy:AppDataProxy;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourcesHelper(basesListProxy:BasesListProxy=null, appDataProxy:AppDataProxy=null)
		{
			_basesListProxy = basesListProxy;
			_appDataProxy = appDataProxy;
		}
		
		/**
		 * Узнать, хватает ли ресурсов на оплату
		 * @param priceVO цена
		 * @return true, если ресурсов хватает
		 */
		public function isEnoughResources(price:PriceVO):Boolean
		{
            if (!price || price.children.length == 0)
                return true;
            
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
		 * Инвертировать цену
		 * @param sourcePrice исходная цена
		 * @return цена, где все значения представлены с противоположным знаком
		 */
		public function invertPrice(sourcePrice:PriceVO):PriceVO
		{
			var invert:PriceVO = new PriceVO();
			for each (var resource:ResourceVO in sourcePrice.children)
			{
				var ires:ResourceVO = ResourceVO(resource.clone());
				ires.resourceCount *= -1;
				invert.children.push(ires);
			}
			return invert;
		}
		
		/**
		 * Разделить цену на дебет и кредит (положительные и отрицательные значения)
		 * @param sourcePrice исходная цена
		 * @param invertCredit инвертировать кредит (чтобы получить положительные значения)
		 * @return массив из двух цен 0 - дебет, 1 - кредит
		 */
		public function separatePrice(sourcePrice:PriceVO, invertCredit:Boolean=false):Vector.<PriceVO>
		{
			var dc:Vector.<PriceVO> = new <PriceVO>[ new PriceVO(), new PriceVO() ];
			for each (var resource:ResourceVO in sourcePrice.children)
			{
				var cres:ResourceVO = ResourceVO(resource.clone());
				if (resource.resourceCount > 0)
				{
					dc[0].children.push(cres);
				}
				else if (resource.resourceCount < 0)
				{
					if (invertCredit)
						cres.resourceCount *= -1;
					dc[1].children.push(cres);
				}
			}
			return dc;
		}
		
		/**
		 * Объединить несколько цен в одну
		 * @param args набор объединяемых цен
		 * @return суммарная цена
		 */
		public function joinPrice(...args):PriceVO
		{
			if (args.length == 1)
				return args[0];
			
			var price:PriceVO = new PriceVO();
			for each (var src:PriceVO in args)
			{
				if (!src)
					continue;
				
				var resourceAlreadyExists:Boolean = false;
				for each (var srcRes:ResourceVO in src.children)
				{
					for each (var priceRes:ResourceVO in price.children)
					{
						if (srcRes.resourceId == priceRes.resourceId)
						{
							priceRes.resourceCount += srcRes.resourceCount;
							resourceAlreadyExists = true;
							break;
						}
					}
					
					if (!resourceAlreadyExists)
						price.children.push(srcRes.clone());
				}
			}
			return price;
		}
		
        /**
         * Узнать, хватает ли места, если добавляются указанные ресурсы
         * @param price добавляемые ресурсы
         * @return true, если места хватает
         */
        public function isEnouchSpace(price:PriceVO):Boolean
        {
            if (!price || price.children.length == 0)
                return true;
            
            var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(ModuleDescVO.STORE);
            if (!moduleDesc)
                return false;
            
            var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy);
            for each (var requiredRes:ResourceVO in price.children)
            {
                if (requiredRes.resourceDesc.resourceSize == 0 || requiredRes.resourceCount <= 0)
                    continue;
                
                var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
                var rest:int = requiredRes.resourceCount;
                
                for each (var base:BaseVO in bases)
                {
                    // сколко единиц ресурса поместится в найденное свободное пространство
                    var freeSpace:int = modulesHelper.getSpace(ModuleDescVO.STORE, base) / requiredRes.resourceDesc.resourceSize;
                    
                    if (freeSpace == 0)
                        continue;	// Для этого ресурса места нет
                    
                    var filled:int;	// Место, которое будет занято ресурсом на складах
                    if (rest > freeSpace)
                    {
                        filled = freeSpace * requiredRes.resourceDesc.resourceSize;
                        rest -= freeSpace;
                    }
                    else
                    {
                        filled = rest * requiredRes.resourceDesc.resourceSize;
                        rest = 0;
                    }
                    
                    if (rest == 0)
                        break;
                }
                
                if (rest > 0)
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
            if (!price)
                return true;
            
            var dc:Vector.<PriceVO> = separatePrice(price, true);
            if (isEnoughResources(dc[0]) && isEnouchSpace(dc[1]))
            {
                ProtoFacade.getInstance().sendNotification(Const.CHANGE_RESOURCES, invertPrice(price));
                return true;
            }
            
            return false;
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
         * Удалить ресурсы
         * @param resourceId идентификатор ресурса
         * @param resourceCount удаляемое количество ресурса
         * @return остаток, который не удалось удалить (будет больше нуля, если ресурсов на складах не хватило)
         */
        public function removeResource(resourceId:uint, resourceCount:int):int
        {
            if (resourceCount <= 0)
                return 0;
            
            var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
            
            if (bases.length == 0)
                return resourceCount;
            
            var count:int = resourceCount;
            
            for each (var base:BaseVO in bases)
            {
                var store:StoreVO = base.baseStore;
                for each (var availableRes:ResourceVO in store.children)
                {
                    if (availableRes.resourceId == resourceId)
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
                            count = 0;
                            availableRes.resourceCount = rest;
                        }
                        break;
                    }
                }
                
                if (count == 0)
                    break;
            }
            
            return count;
        }
		
		/**
		 * Добавить ресурсы
		 * @param resourceId идентификатор ресурса
		 * @param resourceCount добавляемое количество ресурса
		 * @return количество ресурса, размещенное на складах (будет меньше добавляемого количества, если складов не хватает)
		 */
		public function addResource(resourceId:uint, resourceCount:int):int
		{
			var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(ModuleDescVO.STORE);
			var resourceDesc:ResourceDescVO = ResourcesDict.getInstance().getResource(resourceId);
			
			if (!moduleDesc || !resourceDesc || resourceCount <= 0)
				return 0;
			
			var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
			var rest:int = resourceCount;
			
			var modulesHelper:ModulesHelper = new ModulesHelper(basesListProxy);
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
					// сколко единиц ресурса поместится в найденное свободное пространство
					var freeSpace:int = modulesHelper.getSpace(ModuleDescVO.STORE, base) / resourceDesc.resourceSize;
					
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
					
					addResourceToBase(base, resourceId, resourceCount - rest);
				}
				
				if (rest == 0)
					break;
			}
			
			return resourceCount - rest;
		}
		
		private function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
				_basesListProxy = BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
			return  _basesListProxy;
		}
		
		private function get appDataProxy():AppDataProxy
		{
			if (!_appDataProxy)
				_appDataProxy = AppDataProxy(ProtoFacade.getInstance().retrieveProxy(AppDataProxy.NAME));
			return _appDataProxy;
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
	}
}