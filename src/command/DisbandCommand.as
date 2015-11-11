package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.RaidsProxy;
    import proxy.TimersProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseVO;
    import vo.RaidVO;
    import vo.TimerVO;
    
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