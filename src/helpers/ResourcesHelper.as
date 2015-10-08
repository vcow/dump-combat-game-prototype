package helpers
{
	import dictionary.DefaultsDict;
	import dictionary.ModulesDict;
	
	import facade.ProtoFacade;
	
	import proxy.BasesListProxy;
	
	import vo.BaseVO;
	import vo.ModuleDescVO;
	import vo.PriceVO;
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
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ResourcesHelper(basesListProxy:BasesListProxy=null)
		{
			_basesListProxy = basesListProxy;
		}
        
        /**
         * Проверить, является ли ресурс неблокируемым при неактивных складах
         * @param resourceId идентификатор ресурса
         * @return true, если ресурс неблокируемый
         */
        public function isUnlockable(resourceId:String):Boolean
        {
            for each (var resource:ResourceVO in DefaultsDict.getInstance().unlockedResourcesList.children)
            {
                if (resource.resourceId == resourceId)
                    return true;
            }
            return false;
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
            
			var store:StoreVO = getAllResources();
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
            if (sourcePrice)
            {
    			for each (var resource:ResourceVO in sourcePrice.children)
    			{
    				var ires:ResourceVO = ResourceVO(resource.clone());
    				ires.resourceCount *= -1;
    				invert.children.push(ires);
    			}
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
         * Добавить указанный ресурс в цену
         * @param resourceId идентификатор добавляемого ресурса
         * @param resourceCount количество добавляемого ресурса
         * @param price цена, в которую нужно добавить ресурс, если null, создается новая
         * @return цена с добавленным ресурсом
         */
        public function joinResource(resourceId:String, resourceCount:int, price:PriceVO=null):PriceVO
        {
            if (!price)
                price = new PriceVO();
            
            for each (var resource:ResourceVO in price.children)
            {
                if (resource.resourceId == resourceId)
                {
                    resource.resourceCount += resourceCount;
                    return price;
                }
            }
            
            resource = new ResourceVO();
            resource.resourceId = resourceId;
            resource.resourceCount = resourceCount;
            
            price.children.push(resource);
            return price;
        }
		
		/**
		 * Объединить несколько цен в одну
		 * @param args набор объединяемых цен
		 * @return суммарная цена
		 */
		public function joinPrice(...args):PriceVO
		{
			if (args.length == 1)
				return args[0] is PriceVO ? args[0] : new PriceVO();
			
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
            
            for (var i:int = price.children.length - 1; i >= 0; i--)
            {
                if (ResourceVO(price.children[i]).resourceCount == 0)
                    price.children.splice(i, 1);
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
                    
                    if (freeSpace <= 0)
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
                    
                    if (rest <= 0)
                        break;
                }
                
                if (rest > 0)
                    return false;
            }
            
            return true;
        }
		
		/**
		 * Получить количество указанного ресурса
		 * @param resourceId идентификатор ресурса
		 * @return количество ресурса
		 */
		public function getResource(resourceId:String):int
		{
			var store:StoreVO = getAllResources();
			for each (var value:ResourceVO in store.children)
			{
				if (value.resourceId == resourceId)
					return value.resourceCount;
			}
			return 0;
		}
		
		private function get basesListProxy():BasesListProxy
		{
			if (!_basesListProxy)
				_basesListProxy = BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
			return  _basesListProxy;
		}
		
		/**
		 * Получить список всех доступных ресурсов
		 * @return список всех доступных ресурсов
		 */
		private function getAllResources():StoreVO
		{
			var store:StoreVO = new StoreVO();
			
			var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
			if (bases.length > 0)
			{
				for each (var base:BaseVO in bases)
					store.append(base.baseStore);
			}
			
			return store;
		}
	}
}