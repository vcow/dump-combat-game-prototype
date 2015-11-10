package command
{
	import dictionary.BasesDict;
	import dictionary.Const;
	
	import helpers.PropertyHelper;
	import helpers.ResourcesHelper;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import proxy.AppDataProxy;
	import proxy.BasesListProxy;
	import proxy.TriggersProxy;
	
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
                base.baseId = baseTempl.baseId;
                base.baseName = baseTempl.baseName;
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
                var ruinModules:ModulesVO = ruin.ruinModules;
                
                var templateModules:ModulesVO = baseTempl.getBaseModules(AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)).currentLevel);
                modules.modulesMaxCount = templateModules ? templateModules.modulesMaxCount : (ruinModules ? ruinModules.children.length : 0);
                
                if (ruinModules)
                {
                    var numModules:int = Math.min(modules.modulesMaxCount, ruinModules.children.length);
                    for (i = 0; i < numModules; i++)
                        modules.children.push(ModuleVO(ruinModules.children[i]).clone());
                }
                
                var triggersProxy:TriggersProxy = TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME));
                triggersProxy.valueChanged(TriggersProxy.BASES_COUNT_TRIGGER);
                if (base.baseModules.children.length > 0)
                    triggersProxy.valueChanged(TriggersProxy.MODULES_COUNT_TRIGGER);
                
                (new PropertyHelper(basesListProxy)).redistributeProperty();
                
                sendNotification(Const.NEW_BASE_CREATED, base);
            }
		}
	}
}