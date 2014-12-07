package command
{
	import dictionary.Const;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.BasesListProxy;
	import proxy.ResourcesListProxy;
	
	import vo.BaseVO;
	import vo.IVO;
	import vo.RuinVO;
	
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
		 * @param ruinVO руины, на которых создается база
		 */
		private function createBase(ruinVO:RuinVO):void
		{
			var basesListProxy:BasesListProxy = this.facade.retrieveProxy(BasesListProxy.NAME) as BasesListProxy;
			var resourcesListProxy:ResourcesListProxy = this.facade.retrieveProxy(ResourcesListProxy.NAME) as ResourcesListProxy;
			if (basesListProxy && resourcesListProxy)
			{
				var numChildren:int = basesListProxy.basesListVO.children.length;
				for (var i:int = 0; i < numChildren; i++)
				{
					var value:IVO = basesListProxy.basesListVO.children[i];
					if (value is RuinVO && RuinVO(value).ruinId == ruinVO.ruinId)
					{
						basesListProxy.basesListVO.children.splice(i, 1);
						break;
					}
				}
				
				resourcesListProxy.pay(ruinVO.price);
				
				var baseVO:BaseVO = new BaseVO();
				baseVO.baseId = ruinVO.ruinId;
				baseVO.baseName = ruinVO.ruinName;
				
				basesListProxy.basesListVO.children.push(baseVO);
				sendNotification(Const.NEW_BASE_CREATED, baseVO);
			}
		}
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
			var resourcesListProxy:ResourcesListProxy = this.facade.retrieveProxy(ResourcesListProxy.NAME) as ResourcesListProxy;
			var ruinVO:RuinVO = notification.getBody() as RuinVO;
			
			if (resourcesListProxy && ruinVO)
			{
				if (resourcesListProxy.isEnoughResources(ruinVO.price))
					createBase(ruinVO);
			}
			else
			{
				// Не хватает ресурсов, запустить сценарий покупки ресурсов
			}
		}
	}
}