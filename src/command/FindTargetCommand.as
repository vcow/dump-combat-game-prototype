package command
{
    import mx.resources.ResourceManager;
    
    import command.data.FindTargetCmdData;
    
    import dictionary.BasesDict;
    import dictionary.Const;
    
    import helpers.PropertyHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    import proxy.TriggersProxy;
    
    import vo.BaseTemplVO;
    import vo.BaseVO;
    import vo.IVO;
    import vo.RuinVO;
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
            var data:FindTargetCmdData = notification.getBody() as FindTargetCmdData;
            if (data)
            {
                var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(data.baseId);
                if (baseTempl)
                {
                    var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                    
                    var base:IVO = basesListProxy.getBase(baseTempl.baseId);
                    if (base)
                    {
                        // Эта база уже есть в списке известных
                        switch (base.name)
                        {
                            case RuinVO:
                                // Эта база ранее числилась в руинах, удалить ее из руин и пересоздать как цель
                                for (var i:int = 0; i < basesListProxy.basesListVO.children.length; i++)
                                {
                                    base = basesListProxy.basesListVO.children[i];
                                    if (base.name == RuinVO.NAME && RuinVO(base).ruinId == baseTempl.baseId)
                                    {
                                        basesListProxy.basesListVO.children.splice(i, 1);
                                        break;
                                    }
                                }
                                break;
                            case TargetVO.NAME:
                                if (EnemiesProxy(this.facade.retrieveProxy(EnemiesProxy.NAME)).getOwner(data.baseId) != data.ownerId)
                                {
                                    // У этой базы сменился владелец
                                    (new PropertyHelper(basesListProxy)).redistributeProperty(data.baseId, data.ownerId);
                                }
                                return;
                            case BaseVO.NAME:
                                // Юзер нашел собственную базу
                                return;
                        }
                    }
                    
                    var target:TargetVO = new TargetVO();
                    target.targetId = baseTempl.baseId;
                    target.targetName = baseTempl.baseName;
                    
                    basesListProxy.basesListVO.children.push(target);
                    
                    TriggersProxy(this.facade.retrieveProxy(TriggersProxy.NAME)).valueChanged(TriggersProxy.TARGETS_COUNT_TRIGGER);
                    
                    (new PropertyHelper(basesListProxy)).redistributeProperty(data.baseId, data.ownerId);
                    
                    sendNotification(Const.TARGET_FOUND, target.targetId);
                    
                    var message:String = ResourceManager.getInstance().getString("messages", "base.found", [ target.targetName ]);
                    sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                }
            }
        }
    }
}