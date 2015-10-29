package helpers
{
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
         * Получить свойство юнита
         * @param propertyName название свойства
         * @param unitId идентификатор юнита
         * @return значение свойства
         */
        public function getUnitProperty(propertyName:String, unitId:String):Number
        {
            var unit:UnitVO = _armyProxy.getUnit(unitId);
            
            if (!unit)
                return 0;
            
            var modifiers:ModifiersVO = unit.unitDesc.unitModifiers;
            var value:Number = modifiers ? modifiers.getFieldValue(propertyName) : NaN;
            
            if (isNaN(value))
                value = 0;
            
            value = updateValueWith(propertyName, unit.children, value);
            
            return value;
        }
        
        /**
         * Вспомогательная функция, суммирует эффекты от всего задействованного вооружения
         * @param propertyName название параметра
         * @param items список вооружения
         * @param baseValue базовое значение параметра
         * @return модифицированное значение параметра
         */
        private function updateValueWith(propertyName:String, items:Vector.<IVO>, baseValue:Number):Number
        {
            var weaponList:Vector.<WeaponVO> = new Vector.<WeaponVO>();
            var armorList:Vector.<ArmorVO> = new Vector.<ArmorVO>();
            var ammoList:Vector.<AmmoVO> = new Vector.<AmmoVO>();
            
            var armamentDict:ArmamentDict = ArmamentDict.getInstance();
            
            for (var i:int = 0; i < items.length; i++)
            {
                var item:IVO = items[i];
                switch (item.name)
                {
                    case WeaponVO.NAME: weaponList.push(WeaponVO(item)); break;
                    case ArmorVO.NAME: armorList.push(ArmorVO(item)); break;
                    case AmmoVO.NAME: ammoList.push(AmmoVO(item)); break;
                }
            }
            
            for (i = 0; i < weaponList.length; i++)
            {
                var weapon:WeaponVO = weaponList[i];
                var modifiers:ModifiersVO = weapon.weaponDesc.weaponModifiers;
                baseValue = modifiers ? modifiers.getFieldValue(propertyName, baseValue) : baseValue;
                
                baseValue = updateValueWith(propertyName, weapon.children, baseValue);
            }
            
            for (i = 0; i < armorList.length; i++)
            {
                var armor:ArmorVO = armorList[i];
                modifiers = armor.armorDesc.armorModifiers;
                baseValue = modifiers ? modifiers.getFieldValue(propertyName, baseValue) : baseValue;
            }
            
            if (ammoList.length > 0)
            {
                var ammo:AmmoVO = ammoList[0];
                modifiers = ammo.ammoDesc.ammoModifiers;
                baseValue = modifiers ? modifiers.getFieldValue(propertyName, baseValue) : baseValue;
            }
            
            return baseValue;
        }
    }
}