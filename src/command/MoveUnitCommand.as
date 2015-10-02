package command
{
    import command.data.MovePersonCmdData;
    
    import helpers.ArmyHelper;
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    import vo.ModuleDescVO;
    import vo.UnitVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на перевод боевого юнита на другую базу
     * 
     */
    
    public class MoveUnitCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function MoveUnitCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:MovePersonCmdData = notification.getBody() as MovePersonCmdData;
            if (data)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                var dstBase:BaseVO = basesListProxy.getBase(data.baseId) as BaseVO;
                
                if (!dstBase)
                    return;     // База назначения не найдена
                
                var armyProxy:ArmyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
                var unit:UnitVO = armyProxy.getUnit(data.personId);
                
                if (!unit || !unit.unitDesc)
                    return;     // Юнит не найден
                
                var srcBase:BaseVO = (new ArmyHelper(basesListProxy, null, null, armyProxy)).getUnitPlace(data.personId);
                
                if (!srcBase)
                    return;     // База пребывания не найдена
                
                if ((new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, dstBase) < unit.unitDesc.unitCrew)
                {
                    // На базе назначения отсутствует свободное место для размещения солдат
                    return;
                }
                
                
                
            }
        }
    }
}