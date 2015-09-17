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
        public var ammoSharp:Number;                                    //< Режущий урон
        public var ammoSpike:Number;                                    //< Колющий урон
        public var ammoBlunt:Number;                                    //< Урон от удара
        public var ammoFire:Number;                                     //< Урон от огня
        public var ammoStrength:int;                                    //< Сила снаряда
        public var ammoReach:int;                                       //< Радиус действия
        public var ammoPort:Vector.<String> = new Vector.<String>();    //< Список оружия, для которого годится снаряд
		
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
		
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = ammoId;
            res.@resource = ammoResource;
            res.@sharp = ammoSharp;
            res.@spike = ammoSpike;
            res.@blunt = ammoBlunt;
            res.@fire = ammoFire;
            res.@strength = ammoStrength;
            
            if (ammoReach != 1)
                res.@reach = ammoReach;
            
            if (ammoPort.length > 0)
                res.@twoHanded = ammoPort.join(",");
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
            super.deserialize(data);
            
			// TODO: десериализовать специфичные поля
			
            ammoId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            ammoResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            ammoSharp = data.hasOwnProperty("@sharp") ? Number(data.@sharp) : 0;
            ammoSpike = data.hasOwnProperty("@spike") ? Number(data.@spike) : 0;
            ammoBlunt = data.hasOwnProperty("@blunt") ? Number(data.@blunt) : 0;
            ammoFire = data.hasOwnProperty("@fire") ? Number(data.@fire) : 0;
            ammoStrength = data.hasOwnProperty("@strength") ? int(data.@strength) : 0;
            ammoReach = data.hasOwnProperty("@reach") ? int(data.@reach) : 1;
            
            var portList:Array = data.hasOwnProperty("@port") ? data.@port.toString().split(/\s*,\s*/) : [];
            ammoPort.splice(0, ammoPort.length);
            for each (var port:String in portList)
                ammoPort.push(port);
            
			// /TODO
			
			return true;
		}
	}
}