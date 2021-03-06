package ai.battle
{
    import flash.utils.Dictionary;
    
    import helpers.BattleHelper;
    
    import vo.AmmoVO;
    import vo.ModifiersVO;
    import vo.UnitVO;
    import vo.WeaponVO;

    /**
     * 
     * @author y.vircowskiy
     * Расчет сражения пары
     * 
     */
    
    public class Fight
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _c1:Combatant;
        private var _c2:Combatant;
        
        private var _field:Field;
        
        private var _log:Vector.<String>;
        
        private var _loser:Combatant;
        
        private var _battleDecor:BattleHelper;
        
        private static const MISS_DMG:Number = 0.01;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function Fight(pair:Vector.<Combatant>, field:Field, log:Vector.<String>)
        {
            _battleDecor = new BattleHelper();
            
            _c1 = pair[0];
            _c2 = pair[1];
            
            if (!_c1 || !_c2)
                throw Error("Invalid pair.");
            
            _field = field;
            
            _log = log;
            
            
            if (isNaN(_c1.x) || isNaN(_c1.y))
                _loser = _c1;
            else if (isNaN(_c2.x) || isNaN(_c2.y))
                _loser = _c2;
            else
                calcFight();
        }
        
        /**
         * Расчет шага сражения
         */
        private function calcFight():void
        {
            var dx:Number = _c2.x - _c1.x;
            var dy:Number = _c2.y - _c1.y;
            var l:Number = Math.sqrt(dx * dx + dy * dy);
            
            var params1:Dictionary = _battleDecor.getUnitProperties(_c1.unit);
            var params2:Dictionary = _battleDecor.getUnitProperties(_c2.unit);
            
            if (!calcHit(l, dx, dy, params1, params2, _c1, _c2))
                calcHit(l, -dx, -dy, params2, params1, _c2, _c1);
        }
        
        /**
         * Расчет удара
         * @param d дистанция удара
         * @param params1 параметры бьющего юнита
         * @param params2 параметры избиваемого юнита
         * @param c1 бьющий юнит
         * @param c2 избиваемый юнит
         * @return true, если второй юнит убит
         */
        private function calcHit(l:Number, dx:Number, dy:Number, params1:Dictionary, params2:Dictionary, c1:Combatant, c2:Combatant):Boolean
        {
            var reach:Number = _battleDecor.getMaxUnitProperty(ModifiersVO.REACH, c1.unit, params1);
            if (!isNaN(reach) && reach >= l || l < 1.0)
            {
                // Первый боец находится на расстоянии удара от своего противника
                var dmg:Dictionary = _battleDecor.hit(c1.unit, l);
                
                if (!_battleDecor.hitWeapon)
                {
                    // Произошла какая-то ошибка в расчете, не найдено оружие, нанесшее повреждение.
                    // Для предотвращения зацикливания расчета, считаем, что бьющий промахнулся и нанес урон себе
                    
                    var prop:Number = _battleDecor.getMaxUnitProperty(ModifiersVO.HEALTH, c1.unit, params1);
                    if (!isNaN(prop))
                        _log.push(c1.unit.unitName + " misses and causes damage to itself " + Math.round(prop * MISS_DMG) + " HP.");
                    
                    c1.unit.unitDamage += MISS_DMG;
                    
                    if (c1.unit.unitDamage >= 1.0)
                    {
                        _loser = c1;
                        _log.push(c1.unit.unitName + " killed.");
                        return true;
                    }
                    
                    return false;
                }
                
                // TODO: Здесь можно вставить вероятность промаха, пока считаем, что каждый удар результативный
                
                var delta:Number = c2.unit.unitDamage;
                hit(c2, params2, dmg);
                delta -= c2.unit.unitDamage;
                
                prop = _battleDecor.getMaxUnitProperty(ModifiersVO.HEALTH, c2.unit, params2);
                if (!isNaN(prop))
                {
                    var weapon:String;
                    switch (_battleDecor.hitWeapon.name)
                    {
                        case UnitVO.NAME: weapon = UnitVO(_battleDecor.hitWeapon).unitName; break;
                        case WeaponVO.NAME: weapon = WeaponVO(_battleDecor.hitWeapon).weaponDesc.resourceDesc.resourceName; break;
                        case AmmoVO.NAME: weapon = AmmoVO(_battleDecor.hitWeapon).ammoDesc.resourceDesc.resourceName; break;
                    }
                    _log.push(c1.unit.unitName + " shoots " + weapon + " inflict damage " + c2.unit.unitName + " " + Math.round(prop * delta) + " HP.");
                }
                
                if (c2.unit.unitDamage >= 1.0)
                {
                    // Противник убит
                    _loser = c2;
                    _log.push(c2.unit.unitName + " killed.");
                    return true;
                }
            }
            else
            {
                // Боец не достиг расстояния удара, продолжить сближение
                
                var speed:Number = _battleDecor.getMaxUnitProperty(ModifiersVO.SPEED, c1.unit, params1);
                if (speed && speed > 0)
                {
                    var k:Number = speed / l;
                    
                    var oldX:int = Math.round(c1.x);
                    var oldY:int = Math.round(c1.y);
                    
                    c1.x += dx * k;
                    c1.y += dy * k;
                    
                    var newX:int = Math.round(c1.x);
                    var newY:int = Math.round(c1.y);
                    
                    if (newX != oldX || newY != oldY)
                    {
                        if (_field.moveUnit(c1, newX, newY))
                        {
                            // Боец находится в одной ячейке с другими юнитами, проверить на мину
                            // TODO: 
                        }
                    }
                }
            }
            
            return false;
        }
        
        /**
         * Нанести удар юниту
         * @param combatant юнит, которому наносится удар
         * @param params параметры юнита, по которому наносится удар
         * @param damage наносимые повреждения
         */
        private function hit(combatant:Combatant, params:Dictionary, damage:Dictionary):void
        {
            const dmgProps:Array = [ ModifiersVO.DMG_STRENGTH, ModifiersVO.BLUNT_DMG, ModifiersVO.SHARP_DMG, ModifiersVO.SPIKE_DMG, ModifiersVO.FIRE_DMG ];
            const defProps:Array = [ ModifiersVO.DEF_STRENGTH, ModifiersVO.BLUNT_DEF, ModifiersVO.SHARP_DEF, ModifiersVO.SPIKE_DEF, ModifiersVO.FIRE_DEF ];
            
            var dmg:Array = [];
            var def:Array = [];
            
            for (var i:int = 0; i < 5; i++)
            {
                var value:Number = _battleDecor.getMaxUnitProperty(defProps[i], combatant.unit, params);
                def.push(isNaN(value) ? 0 : value);
                
                value = Number(damage[dmgProps[i]]);
                dmg.push(isNaN(value) ? 0 : value);
            }
            
            var normalize:Function = function(props:Array):void {
                var x:Number = props[1] + props[2] + props[3] + props[4];
                props[1] /= x * props[0];
                props[2] /= x * props[0];
                props[3] /= x * props[0];
                props[4] /= x * props[0];
                props.shift();
            };
            
            normalize(dmg);
            normalize(def);
            
            var d:Number = 0;
            for (i = 0; i < 4; i++)
                d += Math.max(dmg[i] - def[i], 0);
            
            var health:Number = _battleDecor.getMaxUnitProperty(ModifiersVO.HEALTH, combatant.unit, params);
            if (health)
            {
                var msg:String = combatant.unit.unitName + " gets " + Math.round(d) + " points of damage. ";
                
                d /= health;
                combatant.unit.unitDamage += d;
                
                msg += "The current percentage of damage is " + Math.round(combatant.unit.unitDamage * 100.0) + "%.";
                _log.push(msg);
            }
            else
            {
                combatant.unit.unitDamage = 1.0;
            }
        }
    }
}