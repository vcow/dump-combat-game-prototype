package command
{
    import ai.Battle;
    
    import dictionary.BasesDict;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.AppDataProxy;
    import proxy.RaidsProxy;
    
    import vo.ArmyVO;
    import vo.BaseTemplVO;
    import vo.RaidVO;
    import vo.UnitVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на захват базы
     * 
     */
    
    public class AssaultCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function AssaultCommand()
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
                if (raid.raidTargetOwner && !raid.raidDepartureOwner)
                {
                    // Игрок нападает на бота
                    
                    var targetTempl:BaseTemplVO = BasesDict.getInstance().getBase(raid.raidTarget);
                    if (targetTempl)
                    {
                        var army1:Vector.<UnitVO> = new Vector.<UnitVO>();
                        var army2:Vector.<UnitVO> = new Vector.<UnitVO>();
                        
                        for each (var unit:UnitVO in raid.children)
                            army1.push(unit);
                        
                        var targetArmy:ArmyVO = targetTempl.getBaseArmy(AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME)).currentLevel);
                        if (targetArmy)
                        {
                            for each (unit in targetArmy.children)
                                army2.push(unit);
                        }
                        
                        var battle:Battle = new Battle(army1, army2);
                        
                        
                    }
                }
                else
                {
                    // Unsupported
                }
            }
            
            throw Error("_");
        }
    }
}