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
		
        public var armorId:String;                                      //< Уникальный идентификатор
        public var armorSharpDef:Number;                                //< Режущий урон
        public var armorSpikeDef:Number;                                //< Колющий урон
        public var armorBluntDef:Number;                                //< Урон от удара
        public var armorFireDef:Number;                                 //< Урон от огня
        public var armorDefStrength:Number;                             //< Сила брони
        public var armorUnit:Vector.<String> = new Vector.<String>();   //< Список юнитов, для которого годится броня
        public var armorSlot:Vector.<int> = new Vector.<int>();         //< Список слотов, в которые помещается броня
		
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
        
        /**
         * Условие, при котором броня может быть использована
         */
        public function get armorCondition():Object
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
			
            res.@id = armorId;
            res.@resource = armorResource;
            res.@sharpDef = armorSharpDef;
            res.@spikeDef = armorSpikeDef;
            res.@bluntDef = armorBluntDef;
            res.@fireDef = armorFireDef;
            res.@defStrength = armorDefStrength;
            
            if (armorSlot.length > 0)
                res.@slot = armorSlot.join(",");
            
            if (armorUnit.length > 0)
                res.@unit = armorUnit.join(",");
			
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
            
            var itemList:Array = data.hasOwnProperty("@slot") ? data.@slot.toString().split(/\s*,\s*/) : [];
            armorSlot.splice(0, armorSlot.length);
            for each (var item:String in itemList)
            {
                if (!isNaN(parseInt(item)))
                    armorSlot.push(int(item));
            }
            
            itemList = data.hasOwnProperty("@unit") ? data.@unit.toString().split(/\s*,\s*/) : [];
            armorUnit.splice(0, armorUnit.length);
            for each (item in itemList)
                armorUnit.push(item);
            
            for each (var sub:XML in data.child(ConditionVO.NAME))
            {
                var condition:ConditionVO = new ConditionVO();
                condition.deserialize(sub);
                children.push(condition);
            }
            delete data[ConditionVO.NAME];
            
            _data = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}