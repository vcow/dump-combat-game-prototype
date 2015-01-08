package proxy
{
	import dictionary.DefaultsDict;
	import vo.ResourceDescVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import vo.PriceVO;
	import vo.ResourceVO;
	import vo.ResourcesVO;
	
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
		
		public function ResourcesListProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function get resourcesListVO():ResourcesVO
		{
			return getData() as ResourcesVO;
		}
		
		/**
		 * Узнать, хватает ли ресурсов на оплату
		 * @param priceVO цена
		 * @return true, если ресурсов хватает
		 */
		public function isEnoughResources(priceVO:PriceVO):Boolean
		{
			for each (var resourceVO:ResourceVO in priceVO.children)
			{
				if (resourceVO.resourceCount > getResource(resourceVO.resourceId))
					return false;
			}
			return true;
		}
		
		/**
		 * Заплатить указанную цену
		 * @param priceVO цена
		 * @return true, если платеж выполнен успешно, false, если какой-то из ресурсов ушел в минус
		 */
		public function pay(priceVO:PriceVO):Boolean
		{
			var res:Boolean = true;
			for each (var resourceVO:ResourceVO in priceVO.children)
			{
				for each (var value:ResourceVO in resourcesListVO.children)
				{
					if (value.resourceId == resourceVO.resourceId)
					{
						value.resourceCount -= resourceVO.resourceCount;
						res &&= value.resourceCount >= 0;
						break;
					}
				}
			}
			return res;
		}
		
		/**
		 * Получить количество указанного ресурса
		 * @param resourceId идентификатор ресурса
		 * @return количество ресурса
		 */
		public function getResource(resourceId:uint):int
		{
			for each (var value:ResourceVO in resourcesListVO.children)
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
		 */
		public function setResource(resourceId:uint, resourceCount:int):void
		{
			for each (var value:ResourceVO in resourcesListVO.children)
			{
				if (value.resourceId == resourceId)
				{
					if (value.resourceCount != resourceCount)
					{
						value.resourceCount = resourceCount;
						updateApplicationVO();
						return;
					}
				}
			}
			
			value = new ResourceVO();
			value.resourceId = resourceId;
			value.resourceCount = resourceCount;
			
			resourcesListVO.children.push(value);
			updateApplicationVO();
		}
		
		/**
		 * Вспомогательная функция, обновляет данные о ресурсах в ApplicationVO
		 * @param save сохранить обновленные данные
		 */
		private function updateApplicationVO(save:Boolean=true):void
		{
			var appDataProxy:AppDataProxy = this.facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
			
			if (!appDataProxy)
				throw Error("Application Data Proxy must be specified.");
			
			appDataProxy.updateChild(resourcesListVO, save);
		}
		
		//----------------------------------
		//  Proxy
		//----------------------------------
		
		override public function getData():Object
		{
			if (!data)
			{
				var appDataProxy:AppDataProxy = this.facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
				var value:ResourcesVO = appDataProxy ? appDataProxy.getChildByName(ResourcesVO.NAME) as ResourcesVO : null;
				
				if (!value)
					value = DefaultsDict.getInstance().resourcesList;
				
				setData(value);
				updateApplicationVO(false);
			}
			
			return data;
		}
	}
}