package vo
{
    import dictionary.ArmamentDict;

	/**
	 * 
	 * @author jvirkovskiy
	 * Value Object надетой брони
	 * 
	 */
	
	public class ArmorVO extends VO
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public static const NAME:String = "armor";
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public var armorSlot:Vector.<int> = new Vector.<int>();     //< Номер слота брони
		
        private var _armorId:String;
        private var _armorDesc:ArmorDescVO;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		public function ArmorVO()
		{
			super(NAME);
		}
        
        /**
         * Идентификатор оружия
         */
        public function set armorId(value:String):void
        {
            if (value == _armorId)
                return;
            
            _armorId = value;
            _armorDesc = ArmamentDict.getInstance().getArmor(_armorId);
        }
        
        public function get armorId():String
        {
            return _armorId;
        }
        
        public function get armorDesc():ArmorDescVO
        {
            return _armorDesc;
        }
        
		//----------------------------------
		//  VO
		//----------------------------------
		
		override protected function getSelfXMLObject():XML
		{
			var res:XML = super.getSelfXMLObject();
			
			// TODO: Сериализовать специфичные поля
			
            res.@id = armorId;
            res.@slot = armorSlot.join(",");
            
			// /TODO
			
			return res;
		}
		
		override public function deserialize(data:XML):Boolean
		{
			super.deserialize(data);
			
			// TODO: десериализовать специфичные поля
			
            armorId = data.hasOwnProperty("@id") ? data.@id.toString() : "";
            
            var slotList:Array = data.hasOwnProperty("@slot") ? data.@slot.toString().split(/\s*,\s*/) : [];
            armorSlot.splice(0, armorSlot.length);
            for each (var slot:String in slotList)
            {
                if (!isNaN(parseInt(slot)))
                    armorSlot.push(int(slot));
            }
			
			// /TODO
			
			return true;
		}
	}
}
	