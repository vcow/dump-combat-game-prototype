package command
{
    import dictionary.Const;
    
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
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
            var moduleId:String = notification.getBody().toString();
            var modulesDecor:ModulesHelper = new ModulesHelper();
            var module:ModuleVO = modulesDecor.getModule(moduleId);
            if (module)
            {
                if (module.moduleModuleId == ModuleDescVO.STORE)
                {
                    // Проверить, что это не последний складской модуль. Для
                    // продолжения игры требуется хотя бы один складской модуль
                    if (modulesDecor.getModulesCount(ModuleDescVO.STORE) <= 1)
                        return;
                }
                
                var base:BaseVO = modulesDecor.getModulePlace(moduleId);
                var modules:ModulesVO = base.baseModules;
                for (var i:int = 0; i > modules.children.length; i++)
                {
                    if (ModuleVO(modules.children[i]).moduleId == moduleId)
                    {
                        modules.children.splice(i, 1);
                        sendNotification(Const.MODULES_CHANGED, base);
                    }
                }
            }
        }
    }
}