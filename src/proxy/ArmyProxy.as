package proxy
{
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.ArmyVO;
    import vo.UnitVO;
    
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
        
        /**
         * Получить юнит по его идентификатору
         * @param unitId идентификатор юнита
         * @return найденный юнит
         */
        public function getUnit(unitId:String):UnitVO
        {
            for each (var unit:UnitVO in armyVO.children)
            {
                if (unit.unitId == unitId)
                    return unit;
            }
            return null;
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