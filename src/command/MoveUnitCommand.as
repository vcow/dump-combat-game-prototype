package command
{
    import command.data.MovePersonCmdData;
    
    import dictionary.Const;
    
    import helpers.ArmyHelper;
    import helpers.ModulesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.GarrisonVO;
    import vo.MercenaryVO;
    import vo.ModuleDescVO;
    import vo.PersonnelVO;
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
                
                if (unit.unitDesc.unitCrew > 0)
                {
                    if ((new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, dstBase) < unit.unitDesc.unitCrew)
                    {
                        // На базе назначения отсутствует свободное место для размещения солдат
                        return;
                    }
                    
                    var personnel:PersonnelVO = srcBase.basePersonnel;
                    var soldiers:Vector.<EmployeeVO> = new Vector.<EmployeeVO>();
                    for (var i:int = personnel.children.length - 1; i >= 0; i--)
                    {
                        var employee:EmployeeVO = EmployeeVO(personnel.children[i]);
                        for each (var soldierId:String in unit.unitCrew)
                        {
                            if (employee.employeePersonId == soldierId)
                            {
                                soldiers.push(employee);
                                personnel.children.splice(i, 1);
                                break;
                            }
                        }
                        
                        if (soldiers.length == unit.unitCrew.length)
                            break;
                    }
                    
                    personnel = dstBase.basePersonnel;
                    for each (employee in soldiers)
                        personnel.children.push(employee);
                }
                
                var garrison:GarrisonVO = srcBase.baseGarrison;
                for (i = 0; i < garrison.children.length; i++)
                {
                    var mercenary:MercenaryVO = MercenaryVO(garrison.children[i]);
                    if (mercenary.mercenaryUnitId == data.personId)
                    {
                        garrison.children.splice(i, 1);
                        dstBase.baseGarrison.children.push(mercenary);
                        break;
                    }
                }
                
                sendNotification(Const.UNIT_IS_PLACED, unit);
            }
        }
    }
}