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
            var d:Number = Math.sqrt((_c2.x - _c1.x) * (_c2.x - _c1.x) + (_c2.y - _c1.y) * (_c2.y - _c1.y));
            
            var params1:Dictionary = _battleDecor.getUnitProperties(_c1.unit);
            var params2:Dictionary = _battleDecor.getUnitProperties(_c2.unit);
            
            if (!calcHit(d, params1, params2, _c1, _c2))
                calcHit(d, params2, params1, _c2, _c1);
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
        private function calcHit(d:Number, params1:Dictionary, params2:Dictionary, c1:Combatant, c2:Combatant):Boolean
        {
            var reach:Number = _battleDecor.getMaxUnitProperty(ModifiersVO.REACH, c1.unit, params1);
            if (!isNaN(reach) && reach >= d)
            {
                // Первый боец находится на расстоянии удара от своего противника
                var dmg:Dictionary = _battleDecor.hit(c1.unit, d);
                
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
                // Первый боец не достих расстояния удара, продолжить сближение
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
        }
    }
}