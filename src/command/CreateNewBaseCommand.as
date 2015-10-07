package command
{
	import dictionary.BasesDict;
	import dictionary.Const;
	
	import helpers.ResourcesHelper;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.BasesListProxy;
	
	import vo.BaseTemplVO;
	import vo.BaseVO;
	import vo.BasesVO;
	import vo.ModuleVO;
	import vo.ModulesVO;
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
		
		//----------------------------------
		//  SimpleCommand
		//----------------------------------
		
		override public function execute(notification:INotification):void
		{
            var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
			var ruin:RuinVO = basesListProxy.getBase(notification.getBody().toString()) as RuinVO;
            if (ruin)
            {
                var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy);
                
                var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(ruin.ruinId);
                if (baseTempl.baseRuin)
                {
                    if (!resourcesDecor.isEnoughResources(baseTempl.baseRuin.ruinRepairPrice) && basesListProxy.getBasesList().length > 0)
                    {
                        // Не хватает ресурсов для восстановления этой базы
                        sendNotification(Const.OPEN_SHOP, notification);
                        return;
                    }
                    
                    sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.invertPrice(baseTempl.baseRuin.ruinRepairPrice));
                }
                
                var base:BaseVO = new BaseVO();
                base.children.push(new ModulesVO());
                
                var basesList:BasesVO = basesListProxy.basesListVO;
                for (var i:int = 0; i < basesList.children.length; i++)
                {
                    if (basesList.children[i].name == RuinVO.NAME && RuinVO(basesList.children[i]).ruinId == ruin.ruinId)
                    {
                        basesList.children.splice(i, 1);
                        break;
                    }
                }
                
                basesList.children.push(base);
                
                var modules:ModulesVO = base.baseModules;
                var templateModules:ModulesVO = baseTempl.baseModules;
                
                if (templateModules)
                {
                    modules.modulesMaxCount = templateModules.modulesMaxCount;
                    for each (var module:ModuleVO in templateModules.children)
                    {
                        var chance:Number = isNaN(module.moduleChance) ? module.moduleDesc.moduleChance : module.moduleChance;
                        if (chance >= 1.0 || Math.random() < chance)
                            modules.children.push(module.clone());
                    }
                }
            }
		}
	}
}