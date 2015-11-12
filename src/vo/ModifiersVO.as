package vo
{
    import flash.utils.Dictionary;

    /**
     * 
     * @author y.vircowskiy
     * Value Object списка модификаторов
     * 
     */
    
    public class ModifiersVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const CLIP:String = "clip";
        public static const REACH:String = "reach";
        public static const SHARP_DMG:String = "sharpDmg";
        public static const SPIKE_DMG:String = "spikeDmg";
        public static const BLUNT_DMG:String = "bluntDmg";
        public static const FIRE_DMG:String = "fireDmg";
        public static const SHARP_DEF:String = "sharpDef";
        public static const SPIKE_DEF:String = "spikeDef";
        public static const BLUNT_DEF:String = "bluntDef";
        public static const FIRE_DEF:String = "fireDef";
        public static const DMG_STRENGTH:String = "dmgStrength";
        public static const DEF_STRENGTH:String = "defStrength";
        public static const HEALTH:String = "health";
        public static const AGILITY:String = "agility";
        public static const SPEED:String = "speed";
        public static const OBSERVANCY:String = "observancy";
        public static const STEALTHINESS:String = "stealthiness";
        
        public static const NAME:String = "modifiers";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _data:Object = {};
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ModifiersVO()
        {
            super(NAME);
        }
        
        public function get modifiersData():Object
        {
            return _data;
        }
        
        /**
         * Получить значение указанного поля
         * @param baseValues базовые значения (для относительных величин)
         * @return расчетные значение полей
         */
        public function getProperties(baseValues:Dictionary=null):Dictionary
        {
            var props:Dictionary = new Dictionary();
            for (var key:String in baseValues)
                props[key] = (baseValues[key] as Array).slice();
                
            for (key in modifiersData)
            {
                var prev:Array = (props[key] as Array) || [ NaN ];
                
                for (var i:int = 0; i < prev.length; i++)
                {
                    var value:Number = parse(modifiersData[key], Number(prev[i]));
                    if (!isNaN(value))
                        prev[i] = value;
                }
                
                for (i = prev.length - 1; i >= 0; i--)
                {
                    if (isNaN(prev[i]))
                        prev.splice(i, 1);
                }
                
                if (prev.length > 0)
                    props[key] = prev;
            }
            return props;
        }
        
        /**
         * Парсить значение по следующему принципу:
         * X - замещает собой базовое значение
         * (>X) - замещает собой базовое, если больше базового
         * (<X) - замещает собой базовое, если меньше базового
         * (+X) - прибавляется к базовому
         * (-X) - вычитается из базового
         * X% - прибавляется процент от базового
         * -X% - вычитается процент от базового
         * @param value значение для парсинга
         * @param baseValue базовое значение
         * @return расчетное значение
         */
        protected function parse(value:*, baseValue:Number=NaN):Number
        {
            if (value == null)
                return baseValue;
            
            var raw:String = value.toString();
            if (raw.search(/^[0-9\.]+>$/) == 0)
            {
                var res:Number = parseFloat(raw.replace(/^\([0-9\.]+)>$/, "$1"));
                res = isNaN(baseValue) || res > baseValue ? res : baseValue;
            }
            else if (raw.search(/^[0-9\.]+<$/) == 0)
            {
                res = parseFloat(raw.replace(/^([0-9\.]+)<$/, "$1"));
                res = isNaN(baseValue) || res < baseValue ? res : baseValue;
            }
            else if (raw.search(/^\[0-9\.]+\+$/) == 0)
            {
                res = parseFloat(raw.replace(/^([0-9\.]+)\+$/, "$1"));
                res = isNaN(baseValue) ? res : baseValue + res;
            }
            else if (raw.search(/^[0-9\.]+\-$/) == 0)
            {
                res = parseFloat(raw.replace(/^([0-9\.]+)\-$/, "$1"));
                res = isNaN(baseValue) ? res : baseValue - res;
            }
            else if (raw.search(/^[0-9\.]+%\+$/) == 0)
            {
                res = parseFloat(raw.replace(/^([0-9\.]+)%\+$/, "$1"));
                res = isNaN(baseValue) ? NaN : baseValue + (baseValue / 100.0 * res);
            }
            else if (raw.search(/^[0-9\.]+%\-$/) == 0)
            {
                res = parseFloat(raw.replace(/^([0-9\.]+)%\-$/, "$1"));
                res = isNaN(baseValue) ? NaN : baseValue - (baseValue / 100.0 * res);
            }
            else if (raw.search(/^[0-9\.]+%$/) == 0)
            {
                res = parseFloat(raw.replace(/^([0-9\.]+)%$/, "$1"));
                res = isNaN(baseValue) ? NaN : baseValue / 100.0 * res;
            }
            else
            {
                res = parseFloat(raw);
            }
            return res;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            throw Error("Modifiers is readOnly node.");
            return null;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            // TODO: десериализовать специфичные поля
            
            _data = parseAsObject(data);
            
            // /TODO
            
            return true;
        }
    }
}