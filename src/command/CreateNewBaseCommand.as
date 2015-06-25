package command
{
	import dictionary.BasesDict;
	import dictionary.Const;
	import dictionary.DefaultsDict;
	
	import helpers.ResourcesHelper;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.AppDataProxy;
	import proxy.BasesListProxy;
	
	import vo.BaseTemplVO;
	import vo.BaseVO;
	import vo.IVO;
	import vo.ModulesVO;
	import vo.PersonnelVO;
	import vo.PriceVO;
	import vo.ResourceVO;
	import vo.RuinVO;
	import vo.StoreVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Команда Создать Новую Базу
	 * 
	 */
	
	public class CreateNewBaseCommand extends SimpleCommand
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function CreateNewBaseCommand()
		{
			super();
		}
		
		/**
		 * Создать базу
		 * @param ruin руины, на которых создается база
		 */
		private function createBase(ruin:RuinVO):void
		{
			var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
			var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)));
			
			var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(ruin.ruinId);
			
			if (baseTempl && baseTempl.baseRuin)
			{
				var ruinIndex:int = -1;
				for (var i:int = 0; i < basesListProxy.basesListVO.numChildren; i++)
				{
					var value:IVO = basesListProxy.basesListVO.getChildAt(i);
					if (value is RuinVO && RuinVO(value).ruinId == ruin.ruinId)
					{
						ruinIndex = i;
						break;
					}
				}
				
				if (ruinIndex < 0)
					throw Error("Can't find ruin.");
				
				var isFirstBase:Boolean = basesListProxy.basesListVO.numChildren == 1;
				var repairPrice:PriceVO = baseTempl.baseRuin.ruinRepairPrice;
				
				if (resourcesDecor.pay(repairPrice) ||
					isFirstBase && resourcesDecor.isEnoughResources(repairPrice))
				{
					basesListProxy.basesListVO.removeChildAt(ruinIndex);
					
					var base:BaseVO = new BaseVO();
					base.baseId = ruin.ruinId;
					base.baseName = baseTempl.baseName;
					
					var modules:ModulesVO = ruin.ruinModules;
					base.addChild(modules ? modules : new ModulesVO());
					
					base.addChild(new StoreVO());
					
					base.addChild(new PersonnelVO());
					
					basesListProxy.basesListVO.addChild(base);
					
					if (isFirstBase)
					{
						// Если это первая база игрока, кладем на склад ресурсы по
						// умолчанию, за вычетом стоимости базы
						var store:StoreVO = DefaultsDict.getInstance().resourcesList;
						for (i = 0; i < store.numChildren; i++)
						{
                            var availableRes:ResourceVO = ResourceVO(store.getChildAt(i));
							var resourceAdded:Boolean = false;
							for (var j:int = 0; j < repairPrice.numChildren; j++)
							{
                                var requiredRes:ResourceVO = ResourceVO(repairPrice.getChildAt(j));
								if (availableRes.resourceId == requiredRes.resourceId)
								{
									resourcesDecor.addResource(availableRes.resourceId, availableRes.resourceCount - requiredRes.resourceCount);
									resourceAdded = true;
									break;
								}
							}
							
							if (!resourceAdded)
								resourcesDecor.addResource(availableRes.resourceId, availableRes.resourceCount);
						}
					}
					
					sendNotification(Const.NEW_BASE_CREATED, base);
				}
			}
		}
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
			var resourcesDecor:ResourcesHelper = new ResourcesHelper(BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)),
				AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)));
			var ruin:RuinVO = notification.getBody() as RuinVO;
			
			var baseTempl:BaseTemplVO = ruin ? BasesDict.getInstance().getBase(ruin.ruinId) : null;
			
			if (ruin && baseTempl && baseTempl.baseRuin)
			{
				if (resourcesDecor.isEnoughResources(baseTempl.baseRuin.ruinRepairPrice))
				{
					createBase(ruin);
				}
				else
				{
					// Не хватает ресурсов, запустить сценарий покупки ресурсов
				}
			}
		}
	}
}