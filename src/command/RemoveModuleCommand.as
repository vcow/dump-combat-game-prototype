package command
{
    import command.data.RemoveModuleCmdData;
    
    import dictionary.Const;
    
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
    import vo.ModuleVO;
    import vo.ModulesVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на удаление модуля
     * 
     */
    
    public class RemoveModuleCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function RemoveModuleCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:RemoveModuleCmdData = notification.getBody() as RemoveModuleCmdData;
            if (data)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                var base:BaseVO = basesListProxy.getBase(data.baseId) as BaseVO;
                if (base)
                {
                    var modules:ModulesVO = base.baseModules;
                    if (modules)
                    {
                        var removedItemIndex:int = -1;
                        
                        // Если не удается найти модуль по индексу, удаляется модуль указанного типа
                        for (var i:int = 0; i < modules.children.length; i++)
                        {
                            var module:ModuleVO = ModuleVO(modules.children[i]);
                            if (module.moduleId == data.moduleTypeId)
                            {
                                removedItemIndex = i;
                                
                                if (module.moduleIndex == data.moduleIndex)
                                    break;
                            }
                        }
                        
                        if (removedItemIndex >= 0)
                        {
                            if (data.moduleTypeId == ModuleDescVO.STORE)
                            {
                                // Проверить, что это не последний складской модуль. Для
                                // продолжения игры требуется хотя бы один складской модуль
                                if ((new ModulesHelper(basesListProxy)).getModulesCount(ModuleDescVO.STORE) <= 1)
                                    return;
                            }
                            
                            modules.children.splice(removedItemIndex, 1);
                            sendNotification(Const.MODULES_CHANGED, base);
                        }
                    }
                }
            }
        }
    }
}