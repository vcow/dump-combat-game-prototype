package proxy
{
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.InvestigationsVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси внутриигровых триггеров
     * 
     */
    
    public class InvestigationsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "investigationsProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function InvestigationsProxy(data:InvestigationsVO=null)
        {
            super(NAME, data);
        }
        
        public function get investigationsVO():InvestigationsVO
        {
            return getData() as InvestigationsVO;
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:InvestigationsVO = appDataProxy.getChildByName(InvestigationsVO.NAME) as InvestigationsVO;
                
                if (!value)
                    value = new InvestigationsVO();
                
                setData(value);
                
                appDataProxy.updateChild(investigationsVO);
            }
            
            return data;
        }
    }
}