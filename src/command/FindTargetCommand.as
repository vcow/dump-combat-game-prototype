package command
{
    import mx.resources.ResourceManager;
    
    import dictionary.BasesDict;
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    
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
            var baseTempl:BaseTemplVO = BasesDict.getInstance().getBase(notification.getBody().toString());
            if (baseTempl)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                
                if (basesListProxy.getBase(baseTempl.baseId))
                    return;             // Эта база уже есть в списке известных
                
                var target:TargetVO = new TargetVO();
                target.targetId = baseTempl.baseId;
                target.targetName = baseTempl.baseName;
                
                basesListProxy.basesListVO.children.push(target);
                
                var message:String = ResourceManager.getInstance().getString("messages", "base.found", [ target.targetName ]);
                sendNotification(Const.SEND_GAME_MESSAGE, message, Const.WARNING);
                
                sendNotification(Const.TARGET_FOUND, target.targetId);
            }
        }
    }
}