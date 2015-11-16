package helpers
{
    import flash.utils.Dictionary;
    
    import dictionary.ArmamentDict;
    
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
        
        private var _hitDistance:Number;
        private var _hitWeapon:IVO;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function BattleHelper()
        {
        }
        
        /**
         * Нанести удар
         * @param unit идентификатор юнита, наносящего удар
         * @param distsnce дистанция, на которую производится удар
         * @return список повреждений, нанесенных ударом
         */
        public function hit(unit:UnitVO, distsnce:Number):Dictionary
        {
            _hitDistance = distsnce;
            
            var props:Dictionary = updateValueWith(new <IVO>[ unit ], new Dictionary());
            
            var dmg:Dictionary = new Dictionary();
            if (_hitWeapon)
            {
                if (_hitWeapon.name == AmmoVO.NAME)
                    removeAmmo(unit, AmmoVO(_hitWeapon).ammoId);    // Изъять отстрелянный снаряд
                
                const dmgProps:Array = [ ModifiersVO.DMG_STRENGTH, ModifiersVO.BLUNT_DMG, ModifiersVO.SHARP_DMG, ModifiersVO.SPIKE_DMG, ModifiersVO.FIRE_DMG ];
                for each (var dmgProp:String in dmgProps)
                {
                    var p:Array = props[dmgProp] as Array;
                    if (p && p.length > 0)
                        dmg[dmgProp] = p[p.length - 1];
                }
            }
            
            return dmg;
        }
        
        /**
         * Оружие, нанесшее удар
         */
        public function get hitWeapon():IVO
        {
            return _hitWeapon;
        }
        
        /**
         * Получить список всех свойств юнита с модификациями
         * @param unit идентификатор юнита
         * @return список модифицированных свойств
         */
        public function getUnitProperties(unit:UnitVO):Dictionary
        {
            _hitDistance = NaN;
            _hitWeapon = null;
            
            return updateValueWith(new <IVO>[ unit ], new Dictionary());
        }
        
        /**
         * Получить свойство юнита
         * @param propertyName название свойства
         * @param unit идентификатор юнита
         * @return значение свойства
         */
        public function getMaxUnitProperty(propertyName:String, unit:UnitVO, properties:Dictionary=null):Number
        {
            var props:Array = (properties ? properties[propertyName] : getUnitProperties(unit)[propertyName]) as Array;
            if (props && props.length > 0)
            {
                props.sort(Array.NUMERIC);
                return Number(props[props.length - 1]);
            }
            return NaN;
        }
        
        /**
         * Удалить отстрелянный снаряд
         * @param weapon оружие
         * @param ammo снаряд
         */
        private function removeAmmo(weapon:IVO, ammoId:String):Boolean
        {
            for (var i:int = 0; i < weapon.children.length; i++)
            {
                var item:IVO = weapon.children[i];
                if (item.name == AmmoVO.NAME && AmmoVO(item).ammoId == ammoId)
                {
                    weapon.children.splice(i, 1);
                    return true;
                }
            }
            
            for each (item in weapon.children)
            {
                if (removeAmmo(item, ammoId))
                    return true;
            }
            
            return false;
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
                
                if (!isNaN(_hitDistance) && _hitWeapon)
                {
                    if (_hitWeapon)
                    {
                        // Найдено оружие, способное нанести удар на указанное расстояние, прекращаем дальнейший расчет
                        return base;
                    }
                    
                    var reach:Array = base[ModifiersVO.REACH] as Array;
                    if (reach && reach.length > 0)
                    {
                        reach.sort(Array.NUMERIC);
                        if (reach[reach.length - 1] >= _hitDistance)
                        {
                            // Этот юнит может поразить на указанной дистанции, прекратить дальнейший расчет
                            _hitWeapon = unit;
                            return base;
                        }
                    }
                }
            }
            
            for (i = 0; i < weaponList.length; i++)
            {
                var weapon:WeaponVO = weaponList[i];
                modifiers = weapon.weaponDesc.weaponModifiers;
                base = modifiers ? modifiers.getProperties(base) : base;
                
                if (!isNaN(_hitDistance))
                {
                    reach = base[ModifiersVO.REACH] as Array;
                    if (reach && reach.length > 0)
                    {
                        reach.sort(Array.NUMERIC);
                        if (reach[reach.length - 1] >= _hitDistance)
                        {
                            // Это оружие может поразить на указанной дистанции, прекратить дальнейший расчет
                            _hitWeapon = weapon;
                            return base;
                        }
                    }
                }
                
                base = updateValueWith(weapon.children, base);
                
                if (!isNaN(_hitDistance) && _hitWeapon)
                {
                    // Найден снаряд, способный поразить на указанной дистанции, прекратить дальнейший расчет
                    return base;
                }
            }
            
            for (i = 0; i < armorList.length; i++)
            {
                var armor:ArmorVO = armorList[i];
                modifiers = armor.armorDesc.armorModifiers;
                base = modifiers ? modifiers.getProperties(base) : base;
            }
            
            if (ammoList.length > 0)
            {
                var bases:Array = [];
                
                for (i = 0; i < ammoList.length; i++)
                {
                    var ammo:AmmoVO = ammoList[i];
                    modifiers = ammo.ammoDesc.ammoModifiers;
                    var sub:Dictionary = modifiers ? modifiers.getProperties(cloneBase(base)) : cloneBase(base);
                    
                    if (!isNaN(_hitDistance))
                    {
                        reach = sub[ModifiersVO.REACH] as Array;
                        if (reach && reach.length > 0)
                        {
                            reach.sort(Array.NUMERIC);
                            if (reach[reach.length - 1] >= _hitDistance)
                            {
                                // Этот снаряд может поразить на указанной дистанции, прекратить дальнейший расчет
                                _hitWeapon = ammo;
                                return sub;
                            }
                        }
                    }
                    
                    bases.push(sub);
                }
                
                base = joinBases(bases);
            }
            
            return base;
        }
        
        private function cloneBase(base:Dictionary):Dictionary
        {
            var res:Dictionary = new Dictionary();
            for (var key:String in base)
                res[key] = (base[key] as Array).slice();
            return res;
        }
        
        public function joinBases(bases:Array):Dictionary
        {
            var res:Dictionary = new Dictionary();
            for each (var base:Dictionary in bases)
            {
                for (var key:String in base)
                {
                    var values:Array = res[key] as Array;
                    if (values)
                        res[key] = values.concat(base[key] as Array);
                    else
                        res[key] = (base[key] as Array).slice();
                }
            }
            
            for each (values in res)
            {
                if (values.length > 0)
                {
                    values.sort(Array.NUMERIC);
                    var value:Number = values[values.length - 1];
                    for (var i:int = values.length - 2; i >= 0; i--)
                    {
                        if (values[i] == value)
                            values.splice(i, 1);
                        else
                            value = values[i];
                    }
                }
            }
            
            do {
                var hasEmpty:Boolean = false;
                for (key in res)
                {
                    if ((res[key] as Array).length == 0)
                    {
                        delete res[key];
                        hasEmpty = true;
                        break;
                    }
                }
            } while (hasEmpty);
            
            return res;
        }
    }
}