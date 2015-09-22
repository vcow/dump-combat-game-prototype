package proxy
{
    import helpers.PersonnelHelper;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.ArmyVO;
    import vo.BaseVO;
    import vo.PersonVO;
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
        
        /**
         * Вернуть список всех призванных солдат
         * @return список призванных солдат
         */
        public function getCalledUpSoldiers(unitId:String=null, baseId:String=null):Vector.<PersonVO>
        {
            var persons:Vector.<PersonVO> = new Vector.<PersonVO>();
            var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
            var personnelDecor:PersonnelHelper = new PersonnelHelper(null, personsProxy);
            
            for each (var unit:UnitVO in armyVO.children)
            {
                if (unitId && unit.unitUnitId != unitId)
                    continue;
                
                for each (var soldier:String in unit.unitCrew)
                {
                    var base:BaseVO = personnelDecor.getEmployeePlace(soldier);
                    if (baseId && base.baseId != baseId)
                        continue;
                    
                    persons.push(personsProxy.getPerson(soldier));
                }
            }
            
            return persons;
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