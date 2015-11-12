package command
{
    import command.data.AttackBaseCmdData;
    import command.data.FindTargetCmdData;
    
    import dictionary.BasesDict;
    import dictionary.Const;
    import dictionary.EnemiesDict;
    
    import helpers.ArmyHelper;
    import helpers.PropertyHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    import proxy.RaidsProxy;
    import proxy.TimersProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseTemplVO;
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.EnemyDescVO;
    import vo.GarrisonVO;
    import vo.MercenaryVO;
    import vo.PersonnelVO;
    import vo.RaidVO;
    import vo.TargetVO;
    import vo.TimerVO;
    import vo.UnitVO;
    import vo.VO;
    
    /**
     * 
     * @author y.vircowskiy
     * Атака базы
     * 
     */
    
    public class AttackBaseCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function AttackBaseCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:AttackBaseCmdData = notification.getBody() as AttackBaseCmdData;
            if (data)
            {
                var targetTempl:BaseTemplVO = BasesDict.getInstance().getBase(data.target);
                if (!targetTempl)
                    return;         // Цели не существует
                
                var departureTempl:BaseTemplVO = BasesDict.getInstance().getBase(data.departure);
                if (!departureTempl)
                    return;         // Отправной базы не существует
                
                var enemiesProxy:EnemiesProxy = EnemiesProxy(this.facade.retrieveProxy(EnemiesProxy.NAME));
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                
                var targetOwner:String = enemiesProxy.getOwner(targetTempl.baseId);
                var departureOwner:String = enemiesProxy.getOwner(departureTempl.baseId);
                
                if (targetOwner == null)
                {
                    // Нападение на базу игрока
                    
                    if (departureOwner == null)
                        return;     // Игрок напал сам на себя
                    
                    var enemyDesc:EnemyDescVO = EnemiesDict.getInstance().getEnemy(departureOwner);
                    if (!enemyDesc)
                        return;     // Такого врага не существует
                    
                    if (departureOwner == Const.NO_GUID)
                    {
                        // База, с которой поизводится нападение, анонимная. Присвоить ее врагу,
                        // от имени которого происходит нападение
                        departureOwner = enemyDesc.enemyId;
                        (new PropertyHelper(basesListProxy, enemiesProxy)).redistributeProperty(departureTempl.baseId, departureOwner);
                    }
                }
                else if (departureOwner == null)
                {
                    // Нападение игрока на чужую базу
                    
                    if (targetOwner == null)
                        return;     // Игрок напал сам на себя
                    
                    enemyDesc = EnemiesDict.getInstance().getEnemy(targetOwner);
                    if (!enemyDesc)
                        return;     // Такого врага не существует
                    
                    if (targetOwner == Const.NO_GUID)
                    {
                        // База, на которую происходит нападение, анонимная. Присвоить ее врагу,
                        // который значится владельцем базы
                        targetOwner = enemyDesc.enemyId;
                        (new PropertyHelper(basesListProxy, enemiesProxy)).redistributeProperty(targetTempl.baseId, targetOwner);
                    }
                    
                    // Если база еще не числится в целях, сделать ее таковой
                    var target:TargetVO = basesListProxy.getBase(targetTempl.baseId) as TargetVO;
                    if (!target)
                        sendNotification(Const.FIND_TARGET, new FindTargetCmdData(targetTempl.baseId, enemyDesc.enemyId));
                }
                else
                {
                    // Непонятно, кто на кого напал
                    return;
                }
                
                if (data.army.length == 0)
                    return;         // Нападающая армия отсутствует
                
                if (targetOwner == null && departureOwner != Const.NO_GUID ||
                    departureOwner == null && targetOwner != Const.NO_GUID)
                {
                    var raid:RaidVO = new RaidVO();
                    raid.raidId = VO.createGUID();
                    raid.raidTarget = targetTempl.baseId;
                    raid.raidTargetOwner = targetOwner;
                    raid.raidDeparture = departureTempl.baseId;
                    raid.raidDepartureOwner = departureOwner;
                    
                    if (departureOwner == null)
                    {
                        // Если нападает игрок, найти базу приписки юнитов и изъять их из гарнизонов, а также из армии и из списков сотрудников
                        
                        var armyProxy:ArmyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
                        var armyDecor:ArmyHelper = new ArmyHelper(basesListProxy, null, null, armyProxy);
                        
                        var army:Vector.<String> = new Vector.<String>();
                        var soldiers:Vector.<String> = new Vector.<String>();
                        for each (var unit:UnitVO in data.army)
                        {
                            if (!armyDecor.getUnitPlace(unit.unitId))
                                return;     // Этот юнит не найден ни на одной базе игрока
                            
                            army.push(unit.unitId);
                            
                            for each (var soldier:String in unit.unitCrew)
                                soldiers.push(soldier);
                        }
                        
                        for each (var base:BaseVO in basesListProxy.getBasesList())
                        {
                            var garrison:GarrisonVO = base.baseGarrison;
                            if (garrison)
                            {
                                for (var i:int = garrison.children.length - 1; i >= 0 && army.length > 0; i--)
                                {
                                    var mercenary:MercenaryVO = MercenaryVO(garrison.children[i]);
                                    for (var j:int = 0; j < army.length; j++)
                                    {
                                        if (mercenary.mercenaryUnitId == army[j])
                                        {
                                            garrison.children.splice(i, 1);
                                            army.splice(j, 1);
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            var personnel:PersonnelVO = base.basePersonnel;
                            if (personnel)
                            {
                                for (i = personnel.children.length - 1; i >= 0 && soldiers.length > 0; i--)
                                {
                                    var employee:EmployeeVO = EmployeeVO(personnel.children[i]);
                                    for (j = 0; j < soldiers.length; j++)
                                    {
                                        if (employee.employeePersonId == soldiers[j])
                                        {
                                            personnel.children.splice(i, 1);
                                            soldiers.splice(j, 1);
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (army.length > 0)
                            throw Error("Can't find some units for raid on bases (" + army.join(", ") + ").");
                        
                        for each (unit in data.army)
                        {
                            for (i = 0; i < armyProxy.armyVO.children.length; i++)
                            {
                                if (UnitVO(armyProxy.armyVO.children[i]).unitId == unit.unitId)
                                {
                                    armyProxy.armyVO.children.splice(i, 1);
                                    break;
                                }
                            }
                        }
                    }
                    
                    for each (unit in data.army)
                        raid.children.push(unit);
                    
                    var raidsProxy:RaidsProxy = RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME));
                    raidsProxy.raidsVO.children.push(raid);
                    
                    var raidTime:Number = 30000;
                    // TODO: Здесь должена быть калькуляция времени на поход от базы отправления до целевой базы из
                    // расчета сбора армии с разных баз и похода от точки A до точки B, пока считаем, что это время - полминуты
                    
                    var timersProxy:TimersProxy = TimersProxy(this.facade.retrieveProxy(TimersProxy.NAME));
                    var timer:TimerVO = timersProxy.startTimer(raidTime);
                    raid.raidTimer = timer.timerId;
                    
                    TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.RAIDS_COUNT_TRIGGER);
                    sendNotification(Const.CAMPAIGN_BEGAN, raid.raidId);
                }
            }
        }
    }
}