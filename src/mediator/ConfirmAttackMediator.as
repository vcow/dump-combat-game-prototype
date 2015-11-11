package mediator
{
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import proxy.RaidsProxy;
    
    import vo.RaidVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Подтверждение атаки базы от игрока, если условия изменились
     * 
     */
    
    public class ConfirmAttackMediator extends Mediator
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "confirmAttackMediator";
        
        private var _raids:Vector.<RaidVO> = new Vector.<RaidVO>();
        
        private var _raidsProxy:RaidsProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ConfirmAttackMediator(viewComponent:Object=null)
        {
            super(NAME, viewComponent);
        }
        
        protected function get raidsProxy():RaidsProxy
        {
            if (!_raidsProxy)
                _raidsProxy = RaidsProxy(this.facade.retrieveProxy(RaidsProxy.NAME));
            return _raidsProxy;
        }
        
        /**
         * Получить ранее зарегистрированный рейд
         * @param raidId идентификатор рейда
         * @return рейд, или null, если таковой ранее не регистрировался
         */
        protected function getRegisteredRaid(raidId:String):RaidVO
        {
            for each (var raid:RaidVO in _raids)
            {
                if (raid.raidId == raidId)
                    return raid;
            }
            return null;
        }
        
        //----------------------------------
        //  Mediator
        //----------------------------------
        
        override public function listNotificationInterests():Array
        {
            return [ Const.CONFIRM_ATTACK_BASE, Const.DISBAND ];
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var raidId:String = notification.getBody().toString();
            switch (notification.getName())
            {
                case Const.CONFIRM_ATTACK_BASE:
                    if (!getRegisteredRaid(raidId))
                    {
                        var raid:RaidVO = raidsProxy.getRaid(raidId);
                        if (raid)
                        {
                            _raids.push(raid);
                        }
                    }
                    break;
                case Const.DISBAND:
                    raid = getRegisteredRaid(raidId);
                    if (raid)
                    {
                        
                    }
                    break;
            }
        }
    }
}