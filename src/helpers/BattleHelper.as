package helpers
{
    import flash.utils.Dictionary;
    
    import dictionary.ArmamentDict;
    
    import facade.ProtoFacade;
    
    import proxy.ArmyProxy;
    
    import vo.AmmoVO;
    import vo.ArmorVO;
    import vo.IVO;
    import vo.ModifiersVO;
    import vo.UnitVO;
    import vo.WeaponVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор для вспомогательных расчетов по бою
     * 
     */
    
    public class BattleHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _armyProxy:ArmyProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function BattleHelper(armyProxy:ArmyProxy=null)
        {
            _armyProxy = armyProxy || ArmyProxy(ProtoFacade.getInstance().retrieveProxy(ArmyProxy.NAME));
        }
        
        /**
         * Получить список всех свойств юнита с модификациями
         * @param unitId идентификатор юнита
         * @return список модифицированных свойств
         */
        public function getUnitProperties(unitId:String):Dictionary
        {
            var props:Dictionary = new Dictionary();
            var unit:UnitVO = _armyProxy.getUnit(unitId);
            
            if (unit)
                props = updateValueWith(new <IVO>[ unit ], props);
            
            return props;
        }
        
        /**
         * Получить свойство юнита
         * @param propertyName название свойства
         * @param unitId идентификатор юнита
         * @return значение свойства
         */
        public function getUnitProperty(propertyName:String, unitId:String):Number
        {
            return Number(getUnitProperties(unitId)[propertyName]);
        }
        
        /**
         * Вспомогательная функция, суммирует эффекты от всего задействованного вооружения
         * @param items список вооружения
         * @param base базовые значения параметров
         * @return модифицированные значения параметров
         */
        private function updateValueWith(items:Vector.<IVO>, base:Dictionary):Dictionary
        {
            var unitList:Vector.<UnitVO> = new Vector.<UnitVO>();
            var weaponList:Vector.<WeaponVO> = new Vector.<WeaponVO>();
            var armorList:Vector.<ArmorVO> = new Vector.<ArmorVO>();
            var ammoList:Vector.<AmmoVO> = new Vector.<AmmoVO>();
            
            var armamentDict:ArmamentDict = ArmamentDict.getInstance();
            
            for (var i:int = 0; i < items.length; i++)
            {
                var item:IVO = items[i];
                switch (item.name)
                {
                    case UnitVO.NAME: unitList.push(UnitVO(item)); break;
                    case WeaponVO.NAME: weaponList.push(WeaponVO(item)); break;
                    case ArmorVO.NAME: armorList.push(ArmorVO(item)); break;
                    case AmmoVO.NAME: ammoList.push(AmmoVO(item)); break;
                }
            }
            
            for (i = 0; i < unitList.length; i++)
            {
                var unit:UnitVO = unitList[i];
                var modifiers:ModifiersVO = unit.unitDesc.unitModifiers;
                base = modifiers ? modifiers.getProperties(base) : base;
                
                base = updateValueWith(unit.children, base);
            }
            
            for (i = 0; i < weaponList.length; i++)
            {
                var weapon:WeaponVO = weaponList[i];
                modifiers = weapon.weaponDesc.weaponModifiers;
                base = modifiers ? modifiers.getProperties(base) : base;
                
                base = updateValueWith(weapon.children, base);
            }
            
            for (i = 0; i < armorList.length; i++)
            {
                var armor:ArmorVO = armorList[i];
                modifiers = armor.armorDesc.armorModifiers;
                base = modifiers ? modifiers.getProperties(base) : base;
            }
            
            if (ammoList.length > 0)
            {
                var ammo:AmmoVO = ammoList[0];
                modifiers = ammo.ammoDesc.ammoModifiers;
                base = modifiers ? modifiers.getProperties(base) : base;
            }
            
            return base;
        }
    }
}