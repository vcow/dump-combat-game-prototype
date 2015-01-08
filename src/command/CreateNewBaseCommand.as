package command
{
	import dictionary.BasesDict;
	import dictionary.Const;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.BasesListProxy;
	import proxy.ResourcesListProxy;
	
	import vo.BaseTemplVO;
	import vo.BaseVO;
	import vo.IVO;
	import vo.ModulesVO;
	import vo.PersonnelVO;
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
			var basesListProxy:BasesListProxy = this.facade.retrieveProxy(BasesListProxy.NAME) as BasesListProxy;
			var resourcesListProxy:ResourcesListProxy = this.facade.retrieveProxy(ResourcesListProxy.NAME) as ResourcesListProxy;
			
			var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(ruin.ruinId);
			
			if (basesListProxy && resourcesListProxy && baseTempl && baseTempl.baseRuin)
			{
				var numChildren:int = basesListProxy.basesListVO.children.length;
				for (var i:int = 0; i < numChildren; i++)
				{
					var value:IVO = basesListProxy.basesListVO.children[i];
					if (value is RuinVO && RuinVO(value).ruinId == ruin.ruinId)
					{
						basesListProxy.basesListVO.children.splice(i, 1);
						break;
					}
				}
				resourcesListProxy.pay(baseTempl.baseRuin.ruinRepairPrice);
				
				var base:BaseVO = new BaseVO();
				base.baseId = ruin.ruinId;
				base.baseName = baseTempl.baseName;
				
				var modules:ModulesVO = ruin.ruinModules;
				base.children.push(modules ? modules : new ModulesVO());
				
				base.children.push(new StoreVO());
				
				base.children.push(new PersonnelVO());
				
				basesListProxy.basesListVO.children.push(base);
				sendNotification(Const.NEW_BASE_CREATED, base);
			}
		}
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
			var resourcesListProxy:ResourcesListProxy = this.facade.retrieveProxy(ResourcesListProxy.NAME) as ResourcesListProxy;
			var ruin:RuinVO = notification.getBody() as RuinVO;
			
			var baseTempl:BaseTemplVO = ruin ? BasesDict.getInstance().getBase(ruin.ruinId) : null;
			
			if (resourcesListProxy && ruin && baseTempl && baseTempl.baseRuin)
			{
				if (resourcesListProxy.isEnoughResources(baseTempl.baseRuin.ruinRepairPrice))
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