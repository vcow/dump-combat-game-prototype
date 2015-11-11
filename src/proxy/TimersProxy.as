package proxy
{
    import flash.utils.Dictionary;
    
    import dictionary.Const;
    
    import events.EventsManagerEvent;
    
    import helpers.ResultHelper;
    
    import managers.EventsManager;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.EventVO;
    import vo.IVO;
    import vo.ResultVO;
    import vo.TimerVO;
    import vo.TimersVO;
    import vo.VO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси таймеров
     * 
     */
    
    public class TimersProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "timersProxy";
        
        private var _timers:Dictionary = new Dictionary();
        
        private var _appDataProxy:AppDataProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function TimersProxy(data:TimersVO=null)
        {
            super(NAME, data);
        }
        
        public function get timersVO():TimersVO
        {
            return getData() as TimersVO;
        }
        
        /**
         * Обновить информацию в дочернем Value Object
         * @param child VO обновляемого таймера
         */
        public function updateTimer(child:IVO):void
        {
            var person:TimerVO = child as TimerVO;
            if (person)
            {
                for (var i:int = 0; i < timersVO.children.length; i++)
                {
                    var value:TimerVO = TimerVO(timersVO.children[i]);
                    if (value.timerId == person.timerId)
                    {
                        timersVO.children.splice(i, 1);
                        break;
                    }
                }
                
                timersVO.children.push(person);
            }
        }
        
        /**
         * Инициировать таймер
         * @param delay время срабатывания таймера
         * @param result результат завершения таймера
         * @return созданный таймер
         */
        public function startTimer(delay:Number, result:ResultVO=null):TimerVO
        {
            if (isNaN(delay) || delay < 1.0)
                return null;
            
            var now:Number = (new Date()).time;
            var id:String = VO.createGUID();
            
            var timer:TimerVO = new TimerVO();
            timer.timerId = id;
            timer.timerStartTime = now;
            timer.timerDelay = delay;
            
            timersVO.children.push(timer);
            applyTimer(timer);
            
            if (result)
                timer.children.push(result);
            
            return timer;
        }
        
        protected function get appDataProxy():AppDataProxy
        {
            if (!_appDataProxy)
                _appDataProxy = this.facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
            return _appDataProxy;
        }
        
        /**
         * Включить таймер в обработку
         * @param timer таймер
         */
        final protected function applyTimer(timer:TimerVO):void
        {
            var listenForTicks:Boolean = !hasRunningTimers;
            
            var exitTime:Number = appDataProxy.stuff.exitTime;
            if (exitTime && timer.timerStartTime < exitTime)
            {
                // Таймер стартовал в предыдущей игровой сессии
                var restoreTime:Number = appDataProxy.stuff.restoreTime;
                if (restoreTime && restoreTime > exitTime)
                    timer.timerStartTime += restoreTime - exitTime;
            }
            
            _timers[timer.timerId] = timer.timerStartTime + timer.timerDelay;
            
            if (listenForTicks)
                EventsManager.getInstance().addEventListener(EventsManagerEvent.TICK, eventsManager_tickHandler);
        }
        
        /**
         * Вспомогательная функция, показывает наличие запущенных таймеров
         */
        private function get hasRunningTimers():Boolean
        {
            for (var key:String in _timers)
                return true;
            return false;
        }
        
        /**
         * Обработчик игрового тика
         * @param event событие
         */
        private function eventsManager_tickHandler(event:EventsManagerEvent):void
        {
            var now:Number = appDataProxy.stuff.timestamp;
            var oldTimers:Array;
            
            for (var key:String in _timers)
            {
                var timestamp:Number = _timers[key];
                if (now >= timestamp)
                {
                    if (!oldTimers)
                        oldTimers = [];
                    oldTimers.push(key);
                    
                    for (var i:int = 0; i < timersVO.children.length; i++)
                    {
                        var timer:TimerVO = TimerVO(timersVO.children[i]);
                        if (timer.timerId == key)
                        {
                            timersVO.children.splice(i, 1);
                            timerComplete(timer);
                            break;
                        }
                    }
                }
            }
            
            for each (key in oldTimers)
                delete _timers[key];
            
            if (!hasRunningTimers)
                EventsManager.getInstance().removeEventListener(EventsManagerEvent.TICK, eventsManager_tickHandler);
        }
        
        /**
         * Обработчик завершения таймера
         * @param timer завершившийся таймер
         */
        private function timerComplete(timer:TimerVO):void
        {
            var result:ResultVO = timer.timerResult;
            if (result)
            {
                if (!(new ResultHelper()).applyResult(result))
                {
                    for each (var item:IVO in result.children)
                    {
                        switch (item.name)
                        {
                            case EventVO.NAME:
                                var event:EventVO = EventVO(item);
                                sendNotification(Const.GAME_EVENT, timer.timerId, event.eventId);
                                break;
                        }
                    }
                }
            }
            
            sendNotification(Const.TIMER_COMPLETE, timer.timerId);
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function onRegister():void
        {
            getData();
        }
        
        override public function getData():Object
        {
            if (!data)
            {
                var value:TimersVO = appDataProxy.getChildByName(TimersVO.NAME) as TimersVO;
                
                if (value)
                {
                    for each (var timer:TimerVO in value.children)
                        applyTimer(timer);
                }
                else
                {
                    value = new TimersVO();
                }
                
                setData(value);
                
                appDataProxy.updateChild(timersVO);
            }
            
            return data;
        }
    }
}