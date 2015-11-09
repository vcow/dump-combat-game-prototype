package command
{
    import command.data.AttackBaseCmdData;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
    import vo.BaseVO;
    import vo.TargetVO;
    
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
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                
                var target:TargetVO = basesListProxy.getBase(data.target) as TargetVO;
                if (!target)
                    return;     // Нет такой вражеской базы среди известных
                
                var departure:BaseVO = basesListProxy.getBase(data.departure) as BaseVO;
                if (!departure)
                    return;     // Нет такой базы у игрока
                
                for each (var soldierId:String in data.army)
                {
                    
                }
            }
        }
    }
}