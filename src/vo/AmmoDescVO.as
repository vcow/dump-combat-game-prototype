package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object снаряда
	 * 
	 */
	
	public class AmmoDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "ammoDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var ammoId:String;                                       //< Уникальный идентификатор
        public var ammoSharpDmg:Number;                                 //< Режущий урон
        public var ammoSpikeDmg:Number;                                 //< Колющий урон
        public var ammoBluntDmg:Number;                                 //< Урон от удара
        public var ammoFireDmg:Number;                                  //< Урон от огня
        public var ammoDmgStrength:Number;                              //< Сила снаряда
        public var ammoReach:int;                                       //< Радиус действия
        public var ammoUnit:Vector.<String> = new Vector.<String>();    //< Список оружия, для которого годится снаряд
		
		private var _ammoResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function AmmoDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set ammoResource(value:String):void
		{
			if (value == _ammoResource)
				return;
			
            _ammoResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_ammoResource);
		}
		
		public function get ammoResource():String
		{
			return _ammoResource;
		}
		
        /**
         * Описание соответствующего ресурса
         */
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
		}
        
        /**
         * Условие, при котором снаряд может быть использован
         */
        public function get ammoCondition():Object
        {
            for each (var item:IVO in children)
            {
                if (item.name == ConditionVO.NAME)
                    return ConditionVO(item).conditionData;
            }
            return null;
        }
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = ammoId;
            res.@resource = ammoResource;
            res.@sharpDmg = ammoSharpDmg;
            res.@spikeDmg = ammoSpikeDmg;
            res.@bluntDmg = ammoBluntDmg;
            res.@fireDmg = ammoFireDmg;
            res.@dmgStrength = ammoDmgStrength;
            
            if (ammoReach != 1)
                res.@reach = ammoReach;
            
            if (ammoUnit.length > 0)
                res.@unit = ammoUnit.join(",");
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            ammoId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            ammoResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            ammoSharpDmg = data.hasOwnProperty("@sharpDmg") ? Number(data.@sharpDmg) : 0;
            ammoSpikeDmg = data.hasOwnProperty("@spikeDmg") ? Number(data.@spikeDmg) : 0;
            ammoBluntDmg = data.hasOwnProperty("@bluntDmg") ? Number(data.@bluntDmg) : 0;
            ammoFireDmg = data.hasOwnProperty("@fireDmg") ? Number(data.@fireDmg) : 0;
            ammoDmgStrength = data.hasOwnProperty("@dmgStrength") ? Number(data.@dmgStrength) : 0;
            ammoReach = data.hasOwnProperty("@reach") ? int(data.@reach) : 1;
            
            var unitList:Array = data.hasOwnProperty("@unit") ? data.@unit.toString().split(/\s*,\s*/) : [];
            ammoUnit.splice(0, ammoUnit.length);
            for each (var unit:String in unitList)
                ammoUnit.push(unit);
            
			// /TODO
			
			return true;
		}
	}
}