package command
{
	import helpers.ResourcesHelper;
	
	import dictionary.BasesDict;
	import dictionary.Const;
	import dictionary.DefaultsDict;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
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
			var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy);
			
			var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(ruin.ruinId);
			
			if (baseTempl && baseTempl.baseRuin)
			{
				var numChildren:int = basesListProxy.basesListVO.children.length;
				var ruinIndex:int = -1;
				for (var i:int = 0; i < numChildren; i++)
				{
					var value:IVO = basesListProxy.basesListVO.children[i];
					if (value is RuinVO && RuinVO(value).ruinId == ruin.ruinId)
					{
						ruinIndex = i;
						break;
					}
				}
				
				if (ruinIndex < 0)
					throw Error("Can't find ruin.");
				
				var isFirstBase:Boolean = numChildren == 1;
				var repairPrice:PriceVO = baseTempl.baseRuin.ruinRepairPrice;
				
				if (isFirstBase && resourcesDecor.isEnoughResources(repairPrice) || resourcesDecor.pay(repairPrice))
				{
					basesListProxy.basesListVO.children.splice(ruinIndex, 1);
					
					var base:BaseVO = new BaseVO();
					base.baseId = ruin.ruinId;
					base.baseName = baseTempl.baseName;
					
					var modules:ModulesVO = ruin.ruinModules;
					base.children.push(modules ? modules : new ModulesVO());
					
					base.children.push(new StoreVO());
					
					base.children.push(new PersonnelVO());
					
					basesListProxy.basesListVO.children.push(base);
					
					if (isFirstBase)
					{
						// Если это первая база игрока, кладем на склад ресурсы по
						// умолчанию, за вычетом стоимости базы
						var store:StoreVO = DefaultsDict.getInstance().resourcesList;
						for each (var availableRes:ResourceVO in store.children)
						{
							var resourceAdded:Boolean = false;
							for each (var requiredRes:ResourceVO in repairPrice.children)
							{
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
						
						sendNotification(Const.RESOURCES_CHANGED);
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
			var ruin:RuinVO = notification.getBody() as RuinVO;
			
			var baseTempl:BaseTemplVO = ruin ? BasesDict.getInstance().getBase(ruin.ruinId) : null;
			
			if (ruin && baseTempl && baseTempl.baseRuin)
			{
				if ((new ResourcesHelper()).isEnoughResources(baseTempl.baseRuin.ruinRepairPrice))
				{
					createBase(ruin);
				}
				else
				{
					// Не хватает ресурсов, запустить сценарий покупки ресурсов
                    sendNotification(Const.OPEN_SHOP, notification);
				}
			}
		}
	}
}