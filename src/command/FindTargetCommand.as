package command
{
    import mx.resources.ResourceManager;
    
    import command.data.PropertyCmdData;
    
    import dictionary.BasesDict;
    import dictionary.Const;
    import dictionary.EnemiesDict;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseTemplVO;
    import vo.TargetVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда найти вражескую базу
     * 
     */
    
    public class FindTargetCommand extends SimpleCommand
    {
        public function FindTargetCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:PropertyCmdData = notification.getBody() as PropertyCmdData;
            if (data)
            {
                var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(data.baseId);
                if (baseTempl)
                {
                    var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                    
                    if (basesListProxy.getBase(baseTempl.baseId))
                    {
                        // Эта база уже есть в списке известных
                        if (EnemiesProxy(this.facade.retrieveProxy(EnemiesProxy.NAME)).getOwner(data.baseId) != data.ownerId)
                            sendNotification(Const.PROPERTY_REDISTRIBUTION, data);      // У этой базы сменился владелец
                        return;
                    }
                    
                    var target:TargetVO = new TargetVO();
                    target.targetId = baseTempl.baseId;
                    target.targetName = baseTempl.baseName;
                    
                    basesListProxy.basesListVO.children.push(target);
                    
                    TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.TARGETS_COUNT_TRIGGER);
                    
                    sendNotification(Const.PROPERTY_REDISTRIBUTION, data);
                    
                    sendNotification(Const.TARGET_FOUND, target.targetId);
                    
                    var message:String = ResourceManager.getInstance().getString("messages", "base.found", [ target.targetName ]);
                    sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                }
            }
        }
    }
}