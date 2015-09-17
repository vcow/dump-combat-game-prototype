package proxy
{
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.ArmyVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси армии
     * 
     */
    
    public class ArmyProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "armyProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ArmyProxy(data:ArmyVO=null)
        {
            super(NAME, data);
        }
        
        public function get armyVO():ArmyVO
        {
            return getData() as ArmyVO;
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:ArmyVO = appDataProxy.getChildByName(ArmyVO.NAME) as ArmyVO;
                
                if (!value)
                    value = new ArmyVO();
                
                setData(value);
                
                appDataProxy.updateChild(armyVO);
            }
            
            return data;
        }
    }
}