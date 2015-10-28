package proxy
{
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.RaidVO;
    import vo.RaidsVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси военных рейдов
     * 
     */
    
    public class RaidsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "raidsProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function RaidsProxy(data:RaidsVO=null)
        {
            super(NAME, data);
        }
        
        public function get raidsVO():RaidsVO
        {
            return getData() as RaidsVO;
        }
        
        /**
         * Получить рейд по его идентификатору
         * @param raidId идентификатор рейда
         * @return рейд
         */
        public function getRaid(raidId:String):RaidVO
        {
            for each (var raid:RaidVO in raidsVO.children)
            {
                if (raid.raidId == raidId)
                    return raid;
            }
            return null;
        }
        
        /**
         * Вернуть список всех удачных рейдов
         * @return список всех удачных рейдов
         */
        public function getFortunateRaids():Vector.<RaidVO>
        {
            var res:Vector.<RaidVO> = new Vector.<RaidVO>();
            for each (var raid:RaidVO in raidsVO.children)
            {
                if (!raid.raidTimer && raid.raidVictorious)
                    res.push(raid);
            }
            return res;
        }
        
        /**
         * Вернуть список всех неудачных рейдов
         * @return список всех неудачных рейдов
         */
        public function getUnfortunateRaids():Vector.<RaidVO>
        {
            var res:Vector.<RaidVO> = new Vector.<RaidVO>();
            for each (var raid:RaidVO in raidsVO.children)
            {
                if (!raid.raidTimer && !raid.raidVictorious)
                    res.push(raid);
            }
            return res;
        }
        
        /**
         * Вернуть список всех активных рейдов
         * @return список всех активных рейдов
         */
        public function getActiveRaids():Vector.<RaidVO>
        {
            var res:Vector.<RaidVO> = new Vector.<RaidVO>();
            for each (var raid:RaidVO in raidsVO.children)
            {
                if (raid.raidTimer)
                    res.push(raid);
            }
            return res;
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:RaidsVO = appDataProxy.getChildByName(RaidsVO.NAME) as RaidsVO;
                
                if (!value)
                    value = new RaidsVO();
                
                setData(value);
                
                appDataProxy.updateChild(raidsVO);
            }
            
            return data;
        }
    }
}