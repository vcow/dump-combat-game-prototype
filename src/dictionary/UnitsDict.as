package dictionary
{
	import vo.UnitDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека юнитов
	 * 
	 */
	
	public final class UnitsDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/units.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:UnitsDict;
        
        private var _units:Vector.<UnitDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function UnitsDict()
        {
            if (_instance != null)
                throw Error("UnitsDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():UnitsDict
		{
			if (!_instance)
				_instance = new UnitsDict();
			return _instance;
		}
        
        /**
         * Получить описание юнита по его идентификатору
         * @param unitId идентификатор описания юнита
         * @return описание юнита
         */
        public function getUnit(unitId:String):UnitDescVO
        {
            init();
            
            for each (var unit:UnitDescVO in _units)
            {
                if (unit.unitId == unitId)
                    return unit;
            }
            return null;
        }
        
        /**
         * Список юнитов
         */
        public function get units():Vector.<UnitDescVO>
        {
            init();
            
            return _units;
        }
		
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private function init():void
        {
			if (!_units)
			{
                _units = new Vector.<UnitDescVO>();
				
				var src:XML = XML(new source());
				var items:XMLList = src.child(UnitDescVO.NAME);
				for each (var item:XML in items)
				{
					var unit:UnitDescVO = new UnitDescVO();
                    unit.deserialize(item);
                    _units.push(unit);
				}
			}
		}
	}
}