package command
{
    import mx.resources.ResourceManager;
    
    import dictionary.Const;
    
    import helpers.ArmyHelper;
    import helpers.ModulesHelper;
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    import proxy.PersonsProxy;
    import proxy.RaidsProxy;
    import proxy.TimersProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.GarrisonVO;
    import vo.MercenaryVO;
    import vo.ModuleDescVO;
    import vo.PersonnelVO;
    import vo.RaidVO;
    import vo.TargetVO;
    import vo.TimerVO;
    import vo.UnitVO;
    
    [ResourceBundle("messages")]
    
    /**
     * 
     * @author y.vircowskiy
     * Проверить состояние рейдов (вызывается из TimerCompleteCommand)
     * 
     */
    
    public class CheckRaidsCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function CheckRaidsCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var timerId:String = notification.getBody().toString();
            var raidsProxy:RaidsProxy = RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME));
            for (var i:int = 0; i < raidsProxy.raidsVO.children.length; i++)
            {
                var raid:RaidVO = RaidVO(raidsProxy.raidsVO.children[i]);
                if (raid.raidTimer == timerId)
                {
                    // Найден рейд, который должен завершиться по этому таймеру
                    
                    if (raid.raidDelayed)
                    {
                        // Завершилось время ожидания решения от игрока, расформировать рейд
                        var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                        var target:TargetVO = basesListProxy.getBase(raid.raidTarget) as TargetVO;
                        var departure:BaseVO = basesListProxy.getBase(raid.raidDeparture) as BaseVO;
                        if (target && departure)
                        {
                            var message:String = ResourceManager.getInstance().getString("messages", "raid.disband", [ target.targetName, departure.baseName ]);
                            sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                        }
                        sendNotification(Const.DISBAND, raid.raidId);
                    }
                    else
                    {
                        raid.raidTimer = "";
                        
                        if (!raid.raidTargetOwner && raid.raidDepartureOwner)
                        {
                            // Нападение бота на игрока
                            
                            if (BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBase(raid.raidTarget) as BaseVO)
                                sendNotification(Const.ASSAULT, raid.raidId);
                            
                            raidsProxy.raidsVO.children.splice(i, 1);
                            sendNotification(Const.CAMPAIGN_COMPLETED, raid.raidId);
                        }
                        else if (raid.raidTargetOwner && !raid.raidDepartureOwner)
                        {
                            // Нападение игрока на бота
                            
                            if (EnemiesProxy(this.facade.retrieveProxy(EnemiesProxy.NAME)).getOwner(raid.raidTarget) == raid.raidTargetOwner)
                            {
                                sendNotification(Const.ASSAULT, raid.raidId);
                                sendNotification(Const.CAMPAIGN_COMPLETED, raid.raidId);
                            }
                            else
                            {
                                // За время похода сменился владелец целевой базы, требуется решение игрока
                                
                                // Дать юзеру на принятие решения пять минут
                                raid.raidDelayed = true;
                                var timer:TimerVO = TimersProxy(this.facade.retrieveProxy(TimersProxy.NAME)).startTimer(300000);
                                raid.raidTimer = timer.timerId;
                                sendNotification(Const.CONFIRM_ATTACK_BASE, raid.raidId);
                            }
                        }
                        else if (!raid.raidTargetOwner && !raid.raidDepartureOwner)
                        {
                            // Демобилизованный отряд вернулся на базу отправки
                            
                            basesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                            departure = basesListProxy.getBase(raid.raidDeparture) as BaseVO;
                            
                            if (departure)
                            {
                                // Вернуть все юниты из отряда в армию и приписать к базе отправки
                                
                                var armyProxy:ArmyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
                                var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
                                var armyDecor:ArmyHelper = new ArmyHelper(basesListProxy, null, personsProxy, armyProxy);
                                var personnelDecor:PersonnelHelper = new PersonnelHelper(basesListProxy, personsProxy);
                                
                                var garrison:GarrisonVO = departure.baseGarrison;
                                if (!garrison)
                                {
                                    garrison = new GarrisonVO();
                                    departure.children.push(garrison);
                                }
                                
                                var personnel:PersonnelVO = departure.basePersonnel;
                                if (!personnel)
                                {
                                    personnel = new PersonnelVO();
                                    departure.children.push(personnel);
                                }
                                
                                for each (var unit:UnitVO in raid.children)
                                {
                                    if (!armyProxy.getUnit(unit.unitId))
                                        armyProxy.armyVO.children.push(unit);
                                    
                                    if (!armyDecor.getUnitPlace(unit.unitId))
                                    {
                                        var mercenary:MercenaryVO = new MercenaryVO();
                                        mercenary.mercenaryUnitId = unit.unitId;
                                        garrison.children.push(mercenary);
                                    }
                                    
                                    for each (var soldier:String in unit.unitCrew)
                                    {
                                        if (!personnelDecor.getEmployeePlace(soldier) && personsProxy.getPerson(soldier))
                                        {
                                            var employee:EmployeeVO = new EmployeeVO();
                                            employee.employeePersonId = soldier;
                                            personnel.children.push(employee);
                                        }
                                    }
                                }
                                
                                if ((new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, departure, true) < 0)
                                {
                                    // После возвращения отряда база перенаселена
                                    message = ResourceManager.getInstance().getString("messages", "raid.departure.is.full", [ departure.baseName ]);
                                    sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                                }
                            }
                            
                            raid.children.splice(0, raid.children.length);
                            TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.RAIDS_COUNT_TRIGGER);
                            sendNotification(Const.CAMPAIGN_COMPLETED, raid.raidId);
                        }
                        else
                        {
                            throw Error("Unexpected raid (" + raid.raidId + ").");
                        }
                    }
                    break;
                }
            }
        }
    }
}