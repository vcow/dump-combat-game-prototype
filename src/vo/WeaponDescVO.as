package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object оружия
	 * 
	 */
	
	public class WeaponDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "weaponDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var weaponId:String;                 //< Уникальный идентификатор
        public var weaponSharpDmg:Number;           //< Режущий урон
        public var weaponSpikeDmg:Number;           //< Колющий урон
        public var weaponBluntDmg:Number;           //< Урон от удара
        public var weaponFireDmg:Number;            //< Урон от огня
        public var weaponDmgStrength:Number;        //< Сила оружия
        public var weaponClip:int;                  //< Объем магазина
        public var weaponReach:int;                 //< Радиус действия
        public var weaponTwoHanded:Boolean;         //< Признак того, что оружие двуручное
		
		private var _weaponResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function WeaponDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set weaponResource(value:String):void
		{
			if (value == _weaponResource)
				return;
			
            _weaponResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_weaponResource);
		}
		
		public function get weaponResource():String
		{
			return _weaponResource;
		}
		
        /**
         * Описание соответствующего ресурса
         */
		public function get resourceDesc():ResourceDescVO
		{
			return _resourceDesc;
		}
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = weaponId;
            res.@resource = weaponResource;
            res.@sharpDmg = weaponSharpDmg;
            res.@spikeDmg = weaponSpikeDmg;
            res.@bluntDmg = weaponBluntDmg;
            res.@fireDmg = weaponFireDmg;
            res.@dmgStrength = weaponDmgStrength;
            
            if (weaponClip > 0)
                res.@clip = weaponClip;
            
            if (weaponReach != 1)
                res.@reach = weaponReach;
            
            if (weaponTwoHanded)
                res.@twoHanded = weaponTwoHanded;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
			
            weaponId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            weaponResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            weaponSharpDmg = data.hasOwnProperty("@sharpDmg") ? Number(data.@sharpDmg) : 0;
            weaponSpikeDmg = data.hasOwnProperty("@spikeDmg") ? Number(data.@spikeDmg) : 0;
            weaponBluntDmg = data.hasOwnProperty("@bluntDmg") ? Number(data.@bluntDmg) : 0;
            weaponFireDmg = data.hasOwnProperty("@fireDmg") ? Number(data.@fireDmg) : 0;
            weaponDmgStrength = data.hasOwnProperty("@dmgStrength") ? Number(data.@dmgStrength) : 0;
            weaponClip = data.hasOwnProperty("@clip") ? int(data.@clip) : 0;
            weaponReach = data.hasOwnProperty("@reach") ? int(data.@reach) : 1;
            weaponTwoHanded = data.hasOwnProperty("@twoHanded") ? data.@twoHanded.toString().toLowerCase() == "true" : false;
            
            _data = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}