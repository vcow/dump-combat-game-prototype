package command
{
    import dictionary.BasesDict;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.AppDataProxy;
    import proxy.BasesListProxy;
    
    import vo.BaseTemplVO;
    import vo.ModuleVO;
    import vo.ModulesVO;
    import vo.RuinVO;
    
    public class FoundRuinsCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function FoundRuinsCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var baseId:String = notification.getBody().toString();
            var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            
            if (basesListProxy.getBase(baseId))
            {
                // Такая база или руины уже есть в списке баз юзера
                return;
            }
            
            var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(baseId);
            
            if (!baseTempl)
            {
                // Не найден шаблон базы
                return;
            }
            
            var ruin:RuinVO = new RuinVO();
            ruin.ruinId = baseTempl.baseId;
            ruin.children.push(new ModulesVO());
            
            basesListProxy.basesListVO.children.push(ruin);
            
            var modules:ModulesVO = ruin.ruinModules;
            var templateModules:ModulesVO = baseTempl.getBaseModules(AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)).currentLevel);
            
            if (templateModules)
            {
                for each (var module:ModuleVO in templateModules.children)
                {
                    var chance:Number = isNaN(module.moduleChance) ? module.moduleDesc.moduleChance : module.moduleChance;
                    if (chance >= 1.0 || Math.random() < chance)
                        modules.children.push(module.clone());
                }
            }
            
            modules.modulesMaxCount = Math.max(templateModules ? templateModules.modulesMaxCount : 0, modules.children.length);
        }
    }
}