package ai
{
    import flash.utils.Dictionary;
    
    import ai.battle.Combatant;
    import ai.battle.Field;
    import ai.battle.Fight;
    
    import helpers.BattleHelper;
    
    import proxy.ArmyProxy;
    
    import vo.ModifiersVO;
    import vo.UnitVO;

    /**
     * 
     * @author y.vircowskiy
     * Рассчет боя
     * 
     */
    
    public class Battle
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private static const DISTANCE:int = 15;     // Расстояние от линии бойцов до центра поля (определяет, насколько разведены армии в начале боя)
        
        private var _army1:Vector.<Combatant>;
        private var _army2:Vector.<Combatant>;
        
        private var _winner:int;
        private var _log:Vector.<String> = new Vector.<String>();
        
        private var _field:Field;
        
        private var _armyProxy:ArmyProxy;
        private var _battleDecor:BattleHelper;
        
        private var _moving1:Vector.<Combatant>;            // Мобильные юниты первой армии
        private var _moving2:Vector.<Combatant>;            // Мобильные юниты второй армии
        
        private var _towers1:Vector.<Combatant>;            // Стационарные юниты дистанционного действия (башни) первой армии
        private var _towers2:Vector.<Combatant>;            // Стационарные юниты дистанционного действия (башни) второй армии
        
        private var _mines1:Vector.<Combatant>;             // Стационарные юниты контактного действия (мины) первой армии
        private var _mines2:Vector.<Combatant>;             // Стационарные юниты контактного действия (мины) второй армии
        
        private var _pairs:Vector.<Vector.<Combatant>>;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Конструктор
         * @param army1 первая армия
         * @param army2 вторая армия
         */
        public function Battle(army1:Vector.<UnitVO>, army2:Vector.<UnitVO>)
        {
            _battleDecor = new BattleHelper();
            
            _army1 = new Vector.<Combatant>();
            for each (var unit:UnitVO in army1)
                _army1.push(new Combatant(unit));
            
            _army2 = new Vector.<Combatant>();
            for each (unit in army2)
                _army2.push(new Combatant(unit));
            
            if (_army1.length == 0 && _army2.length > 0)
                _winner = 2;
            else if (_army1.length > 0 && _army2.length == 0)
                _winner = 1;
            else if (_army1.length == 0 && _army2.length == 0)
                _winner = 0;
            else
                calcBattle();
        }
        
        /**
         * Победитель
         */
        public function get winner():int
        {
            return _winner;
        }
        
        /**
         * Лог боя
         */
        public function get log():Vector.<String>
        {
            return _log;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Расчитать бой
         */
        private function calcBattle():void
        {
            arrangeFighters();
            
            if (_moving1.length == 0 && _moving2.length == 0)
            {
                // В обеих армиях отсутствуют мобильные бойцы. Ничья
                _log.push("No fighters who could move.");
                _winner = 0;
                return;
            }
            
            makePairs();
            
            while (_moving1.length && _moving2.length && _pairs.length)
                calcStep();
            
            if (_moving2.length == 0)
                _winner = 1;
            else if (_moving1.length == 0)
                _winner = 2;
            else
                _winner = 0;
        }
        
        /**
         * Расчитать ход
         */
        private function calcStep():void
        {
            for (var i:int = _pairs.length - 1; i >= 0; i--)
            {
                var fight:Fight = new Fight(_pairs[i], _field, _log);
            }
        }
        
        /**
         * Разбить сражающихся на пары
         */
        private function makePairs():void
        {
            _pairs = new Vector.<Vector.<Combatant>>();
            
            var m1:Vector.<Combatant> = _moving1.slice();
            var m2:Vector.<Combatant> = _moving2.slice();
            
            // Сначала раскидываем по парам мобильных бойцов
            var numPairs:int = Math.min(m1.length, m2.length);
            for (var i:int = 0; i < numPairs; i++)
            {
                var pair:Vector.<Combatant> = new Vector.<Combatant>(2);
                pair[0] = m1.shift();
                pair[1] = m2.shift();
                _pairs.push(pair);
            }
            
            // Те, кто остался незадействованным, атакуют башни
            var m:Vector.<Combatant>;
            var enemies:Vector.<Combatant>;
            var index1:int, index2:int;
            if (m1.length > 0)
            {
                m = m1;
                enemies = _towers2;
                index1 = 0;
                index2 = 1;
            }
            else if (m2.length > 0)
            {
                m = m2;
                enemies = _towers1;
                index1 = 1;
                index2 = 0;
            }
            else
            {
                return;
            }
            
            numPairs = Math.min(m.length, enemies.length);
            for (i = 0; i < numPairs; i++)
            {
                pair = new Vector.<Combatant>(2);
                pair[index1] = m.shift();
                pair[index2] = enemies[i];
                _pairs.push(pair);
            }
            
            if (m.length == 0)
                return;
            
            // Те, кто остался незадействованным, атакуют мины
            enemies = index1 == 0 ? _mines2 : _mines1;
            
            numPairs = Math.min(m.length, enemies.length);
            for (i = 0; i < numPairs; i++)
            {
                pair = new Vector.<Combatant>(2);
                pair[index1] = m.shift();
                pair[index2] = enemies[i];
                _pairs.push(pair);
            }
        }
        
        /**
         * Получить пару для указанного юнита
         * @param unit юнит
         * @return вражеский юнит, null, если пары нет
         */
        private function getPair(unit:Combatant):Combatant
        {
            for each (var pair:Vector.<Combatant> in _pairs)
            {
                for (var i:int = 0; i < 2; i++)
                {
                    if (pair[i] === unit)
                        return Combatant(i == 0 ? pair[1] : pair[0]);
                }
            }
            return null;
        }
        
        /**
         * Расчитать размеры поля и расставить бойцов
         */
        private function arrangeFighters():void
        {
            _moving1 = new Vector.<Combatant>();
            _moving2 = new Vector.<Combatant>();
            
            _towers1 = new Vector.<Combatant>();
            _towers2 = new Vector.<Combatant>();
            
            _mines1 = new Vector.<Combatant>();
            _mines2 = new Vector.<Combatant>();
            
            const armies:Array = [ _army1, _army2 ];
            const moving:Array = [ _moving1, _moving2 ];
            const towers:Array = [ _towers1, _towers2 ];
            const mines:Array = [ _mines1, _mines2 ];
            
            for (var i:int = 0; i < 2; i++)
            {
                var army:Vector.<Combatant> = armies[i];
                var movingUnits:Vector.<Combatant> = moving[i];
                var towerUnits:Vector.<Combatant> = towers[i];
                var mineUnits:Vector.<Combatant> = mines[i];
                
                for each (var unit:Combatant in army)
                {
                    var props:Dictionary = _battleDecor.getUnitProperties(unit.unit);
                    
                    var prop:Number = _battleDecor.getMaxUnitProperty(ModifiersVO.SPEED, unit.unit, props);
                    if (prop)
                    {
                        movingUnits.push(unit);
                        continue;
                    }
                    
                    prop = _battleDecor.getMaxUnitProperty(ModifiersVO.REACH, unit.unit, props);
                    if (prop)
                    {
                        towerUnits.push(unit);
                        continue;
                    }
                    
                    mineUnits.push(unit);
                }
            }
            
            // Высота поля высчитывается из расчета чтобы все башни выстроились в одну линию и/или
            // бойцы выстроились один напротив другого  стенка на стенку
            var h:int = Math.max(_towers1.length, _towers2.length, Math.min(_moving1.length, _moving2.length));
            
            var l1:int, l2:int;                                             // Расстояние от края до первой линии
            l1 += _towers1.length > 0 ? 1 : 0;                             // Добавить линии башен, если есть
            l2 += _towers2.length > 0 ? 1 : 0;
            l1 += _moving1.length / h + (_moving1.length % h ? 1 : 0);    // Добавить линии бойцов
            l2 += _moving2.length / h + (_moving2.length % h ? 1 : 0);
            var w:int = DISTANCE * 2 + l1 + l2;                             // Для ширины берем две дистанции до цента и расстояния от края до первой линии
            
            _field = new Field(w, h);
            
            var x:int = 0;
            var d:int = DISTANCE + l1;
            
            if (_towers1.length > 0)
            {
                // Расставить по левому краю башни первой армии
                var y:int = _towers1.length < h ? (h - _towers1.length) / 2 : 0;
                for each (unit in _towers1)
                    _field.setUnit(unit, x, y++);
                
                x++;
            }
            
            if (_moving1.length > 0)
            {
                // Расставляем бойцов слева
                y = _moving1.length < h ? (h - _moving1.length) / 2 : 0;
                for (i = 0; i < _moving1.length && x < d;)
                {
                    unit = Combatant(_moving1[i]);
                    
                    if (_field.setUnit(unit, x, y++))
                        i++;
                    
                    if (y >= _field.height)
                    {
                        y = (_moving1.length - i) < h ? (h - (_moving1.length - i)) / 2 : 0;
                        x++;
                    }
                }
            }
            
            x = d - 1;
            if (_mines1.length > 0)
            {
                // Расставляем мины слева от центра
                y = _mines1.length < h ? (h - _mines1.length) / 2 : 0;
                for (i = 0; i < _mines1.length && x >= 0;)
                {
                    unit = Combatant(_mines1[i]);
                    
                    if (_field.setUnit(unit, x, y++))
                        i++;
                    
                    if (y >= _field.height)
                    {
                        y = (_mines1.length - i) < h ? (h - (_mines1.length - i)) / 2 : 0;
                        x--;
                    }
                }
            }
            
            x = w - 1;
            d = DISTANCE + l2;
            
            if (_towers2.length > 0)
            {
                // Расставить по правому краю башни первой армии
                y = _towers2.length < h ? (h - _towers2.length) / 2 : 0;
                for each (unit in _towers2)
                    _field.setUnit(unit, x, y++);
                
                x--;
            }
            
            if (_moving2.length > 0)
            {
                // Расставляем бойцов справа
                y = _moving2.length < h ? (h - _moving2.length) / 2 : 0;
                for (i = 0; i < _moving2.length && x > w - d;)
                {
                    unit = Combatant(_moving2[i]);
                    
                    if (_field.setUnit(unit, x, y++))
                        i++;
                    
                    if (y >= _field.height)
                    {
                        y = (_moving2.length - i) < h ? (h - (_moving2.length - i)) / 2 : 0;
                        x--;
                    }
                }
            }
            
            x = w - d;
            if (_mines2.length > 0)
            {
                // Расставляем мины справа от центра
                y = _mines2.length < h ? (h - _mines2.length) / 2 : 0;
                for (i = 0; i < _mines2.length && x < w;)
                {
                    unit = Combatant(_mines2[i]);
                    
                    if (_field.setUnit(unit, x, y++))
                        i++;
                    
                    if (y >= _field.height)
                    {
                        y = (_mines2.length - i) < h ? (h - (_mines2.length - i)) / 2 : 0;
                        x++;
                    }
                }
            }
        }
    }
}