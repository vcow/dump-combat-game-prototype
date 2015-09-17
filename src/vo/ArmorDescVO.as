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
        public var armorSharpDef:Number;           //< Режущий урон
        public var armorSpikeDef:Number;           //< Колющий урон
        public var armorBluntDef:Number;           //< Урон от удара
        public var armorFireDef:Number;            //< Урон от огня
        public var armorDefStrength:Number;        //< Сила брони
		
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
            res.@sharpDef = armorSharpDef;
            res.@spikeDef = armorSpikeDef;
            res.@bluntDef = armorBluntDef;
            res.@fireDef = armorFireDef;
            res.@defStrength = armorDefStrength;
			
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
			
            armorId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            armorResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            armorSharpDef = data.hasOwnProperty("@sharpDef") ? Number(data.@sharpDef) : 0;
            armorSpikeDef = data.hasOwnProperty("@spikeDef") ? Number(data.@spikeDef) : 0;
            armorBluntDef = data.hasOwnProperty("@bluntDef") ? Number(data.@bluntDef) : 0;
            armorFireDef = data.hasOwnProperty("@fireDef") ? Number(data.@fireDef) : 0;
            armorDefStrength = data.hasOwnProperty("@defStrength") ? Number(data.@defStrength) : 0;
            
            _data = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}