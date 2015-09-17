package vo
{
	import dictionary.ResourcesDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object брони
	 * 
	 */
	
	public class ArmorDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "armorDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var armorId:String;                 //< Уникальный идентификатор
        public var armorSharp:Number;              //< Режущий урон
        public var armorSpike:Number;              //< Колющий урон
        public var armorBlunt:Number;              //< Урон от удара
        public var armorFire:Number;               //< Урон от огня
        public var armorStrength:int;              //< Сила брони
		
		private var _armorResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ArmorDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set armorResource(value:String):void
		{
			if (value == _armorResource)
				return;
			
            _armorResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_armorResource);
		}
		
		public function get armorResource():String
		{
			return _armorResource;
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
			
            res.@id = armorId;
            res.@resource = armorResource;
            res.@sharp = armorSharp;
            res.@spike = armorSpike;
            res.@blunt = armorBlunt;
            res.@fire = armorFire;
            res.@strength = armorStrength;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
			
            armorId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            armorResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            armorSharp = data.hasOwnProperty("@sharp") ? Number(data.@sharp) : 0;
            armorSpike = data.hasOwnProperty("@spike") ? Number(data.@spike) : 0;
            armorBlunt = data.hasOwnProperty("@blunt") ? Number(data.@blunt) : 0;
            armorFire = data.hasOwnProperty("@fire") ? Number(data.@fire) : 0;
            armorStrength = data.hasOwnProperty("@strength") ? int(data.@strength) : 0;
            
            _data = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}