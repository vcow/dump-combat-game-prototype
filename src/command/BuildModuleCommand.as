package command
{
import command.data.BuildModuleCmdData;
    
    import dictionary.Const;
    import dictionary.ModulesDict;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.TimersProxy;
    
    import vo.BaseVO;
    import vo.LeadTimeVO;
    import vo.ModuleDescVO;
    import vo.ModuleVO;
    import vo.ModulesVO;
    import vo.PriceVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на создание нового модуля
     * 
     */
    
    public class BuildModuleCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function BuildModuleCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:BuildModuleCmdData = notification.getBody() as BuildModuleCmdData;
            if (data)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                var base:BaseVO = basesListProxy.getBase(data.baseId) as BaseVO;
                if (base)
                {
                    var moduleDesc:ModuleDescVO = ModulesDict.getInstance().getModule(data.moduleTypeId);
                    if (!moduleDesc)
                        return;
                    
                    var price:PriceVO = moduleDesc.modulePrice;
                    if (price)
                    {
                        var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy);
                        if (resourcesDecor.isEnoughResources(price))
                        {
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.invertPrice(price));
                        }
                        else
                        {
                            // TODO: Отправить на докупку ресурсов
                            sendNotification(Const.OPEN_SHOP, notification);
                            return;
                        }
                    }
                    
                    var modules:ModulesVO = base.baseModules;
                    if (modules)
                    {
                        var module:ModuleVO = new ModuleVO();
                        module.moduleId = data.moduleTypeId;
                        module.moduleIndex = modules.nextIndex;
                        
                        var leadTime:LeadTimeVO = moduleDesc.moduleLeadTime;
                        if (leadTime && leadTime.leadTimeTime)
                        {
                            // Модуль строится за определенное время
                            var timerProxy:TimersProxy = TimersProxy(this.facade.retrieveProxy(TimersProxy.NAME));
                            module.moduleBuildTimer = timerProxy.startTimer(leadTime);
                        }
                        
                        modules.children.push(module);
                        sendNotification(Const.MODULES_CHANGED, base);
                    }
                }
            }
        }
    }
}