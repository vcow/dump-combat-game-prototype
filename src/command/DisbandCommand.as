package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    import proxy.RaidsProxy;
    import proxy.TimersProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseVO;
    import vo.PersonVO;
    import vo.RaidVO;
    import vo.TimerVO;
    import vo.UnitVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Демобилизовать отряд
     * 
     */
    
    public class DisbandCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function DisbandCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var raidsProxy:RaidsProxy = RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME));
            var raid:RaidVO = raidsProxy.getRaid(notification.getBody().toString());
            if (raid)
            {
                var departure:BaseVO = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME)).getBase(raid.raidDeparture) as BaseVO;
                if (!departure || raid.raidTargetOwner)
                {
                    // Возвращение невозможно, т. к. база отправки не принадлежит игроку или не найдена. Расформирвать отряд.
                    for (var i:int = 0; i < raidsProxy.raidsVO.children.length; i++)
                    {
                        if (RaidVO(raidsProxy.raidsVO.children[i]).raidId == raid.raidId)
                        {
                            var soldiers:Vector.<String> = new Vector.<String>();
                            for each (var unit:UnitVO in raid.children)
                            {
                                for each (var soldier:String in unit.unitCrew)
                                    soldiers.push(soldier);
                            }
                            
                            var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
                            for (var j:int = personsProxy.personsVO.children.length - 1; j >= 0 && soldiers.length > 0; j--)
                            {
                                var person:PersonVO = PersonVO(personsProxy.personsVO.children[j]);
                                for (var k:int = 0; k < soldiers.length; k++)
                                {
                                    if (person.personId == soldiers[k])
                                    {
                                        personsProxy.personsVO.children.splice(j, 1);
                                        soldiers.splice(k, 1);
                                        break;
                                    }
                                }
                            }
                            
                            raidsProxy.raidsVO.children.splice(i, 1);
                            TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.RAIDS_COUNT_TRIGGER);
                            break;
                        }
                    }
                    return;
                }
                
                raid.raidDelayed = false;
                raid.raidTarget = raid.raidDeparture;
                raid.raidTargetOwner = raid.raidDepartureOwner;
                
                var raidTime:Number = 30000;
                // TODO: Здесь должена быть калькуляция времени на возвращение от целевой базы к базе отправки, пока считаем, что это время - полминуты
                
                var timersProxy:TimersProxy = TimersProxy(this.facade.retrieveProxy(TimersProxy.NAME));
                var timer:TimerVO = timersProxy.startTimer(raidTime);
                raid.raidTimer = timer.timerId;
            }
        }
    }
}