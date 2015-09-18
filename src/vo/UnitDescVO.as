package vo
{
	import dictionary.Const;
	import dictionary.ResourcesDict;

    [ResourceBundle("units")]
    
	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object юнита
	 * 
	 */
	
	public class UnitDescVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "unitDesc";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
        public var unitId:String;                   //< Уникальный идентификатор
        public var unitName:String;                 //< Наименование юнита
        public var unitDescription:String;          //< Описание юнита
        public var unitCrew:int;                    //< Количество солдат в экипаже
        public var unitSharpDmg:Number;             //< Режущий урон
        public var unitSpikeDmg:Number;             //< Колющий урон
        public var unitBluntDmg:Number;             //< Урон от удара
        public var unitFireDmg:Number;              //< Урон от огня
        public var unitDmgStrength:Number;          //< Сила оружия
        public var unitSharpDef:Number;             //< Режущий урон
        public var unitSpikeDef:Number;             //< Колющий урон
        public var unitBluntDef:Number;             //< Урон от удара
        public var unitFireDef:Number;              //< Урон от огня
        public var unitDefStrength:Number;          //< Сила брони
        public var unitClip:int;                    //< Объем магазина
        public var unitReach:int;                   //< Радиус действия
        public var unitSelfDestruct:int;            //< Количество атак до самоуничтожения юнита
		
		private var _unitResource:String;
        private var _data:Object = {};
		
		private var _resourceDesc:ResourceDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function UnitDescVO()
		{
			super(NAME);
		}
		
        /**
         * Идентификатор соответствующего ресурса
         */
		public function set unitResource(value:String):void
		{
			if (value == _unitResource)
				return;
			
            _unitResource = value;
			_resourceDesc = ResourcesDict.getInstance().getResource(_unitResource);
		}
		
		public function get unitResource():String
		{
			return _unitResource;
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
			
            res.@id = unitId;
            res.@name = unitName;
            res.@description = unitDescription;
            res.@crew = unitCrew;
            res.@resource = unitResource;
            res.@sharpDmg = unitSharpDmg;
            res.@spikeDmg = unitSpikeDmg;
            res.@bluntDmg = unitBluntDmg;
            res.@fireDmg = unitFireDmg;
            res.@dmgStrength = unitDmgStrength;
            res.@sharpDef = unitSharpDef;
            res.@spikeDef = unitSpikeDef;
            res.@bluntDef = unitBluntDef;
            res.@fireDef = unitFireDef;
            res.@defStrength = unitDefStrength;
            
            if (unitClip > 0)
                res.@clip = unitClip;
            
            if (unitReach != 1)
                res.@reach = unitReach;
            
            if (unitSelfDestruct > 0)
                res.@selfDestruct = unitSelfDestruct;
            
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			// TODO: десериализовать специфичные поля
			
            unitId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            unitName = data.hasOwnProperty("@name") ? VO.parseString(data.@name, "units") : Const.NO_TEXT;
            unitDescription = data.hasOwnProperty("@description") ? VO.parseString(data.@description, "units") : Const.NO_TEXT;
            unitCrew = data.hasOwnProperty("@crew") ? int(data.@crew) : 0;
            unitResource = data.hasOwnProperty("@resource") ? data.@resource.toString() : "";
            unitSharpDmg = data.hasOwnProperty("@sharpDmg") ? Number(data.@sharpDmg) : 0;
            unitSpikeDmg = data.hasOwnProperty("@spikeDmg") ? Number(data.@spikeDmg) : 0;
            unitBluntDmg = data.hasOwnProperty("@bluntDmg") ? Number(data.@bluntDmg) : 0;
            unitFireDmg = data.hasOwnProperty("@fireDmg") ? Number(data.@fireDmg) : 0;
            unitDmgStrength = data.hasOwnProperty("@dmgStrength") ? Number(data.@dmgStrength) : 0;
            unitSharpDef = data.hasOwnProperty("@sharpDef") ? Number(data.@sharpDef) : 0;
            unitSpikeDef = data.hasOwnProperty("@spikeDef") ? Number(data.@spikeDef) : 0;
            unitBluntDef = data.hasOwnProperty("@bluntDef") ? Number(data.@bluntDef) : 0;
            unitFireDef = data.hasOwnProperty("@fireDef") ? Number(data.@fireDef) : 0;
            unitDefStrength = data.hasOwnProperty("@defStrength") ? Number(data.@defStrength) : 0;
            unitClip = data.hasOwnProperty("@clip") ? int(data.@clip) : 0;
            unitReach = data.hasOwnProperty("@reach") ? int(data.@reach) : 1;
            unitSelfDestruct = data.hasOwnProperty("@selfDestruct") ? int(data.@selfDestruct) : 0;
            
            _data = parseAsObject(data);
			
			// /TODO
			
			return true;
		}
	}
}