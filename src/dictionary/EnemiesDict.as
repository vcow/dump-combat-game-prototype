package dictionary
{
	import vo.EnemyDescVO;
	
	/**
	 * 
	 * @author jvirkovskiy
	 * Библиотека врагов
	 * 
	 */
	
	public final class EnemiesDict
	{
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
		
		[Embed(source="data/enemies.xml", mimeType="application/octet-stream")]
		private static const source:Class;
		
		private static var _instance:EnemiesDict;
		private static var _enemies:Vector.<EnemyDescVO>;
		
		//--------------------------------------------------------------------------
		// 
		//--------------------------------------------------------------------------
        
        public function EnemiesDict()
        {
            if (_instance != null)
                throw Error("EnemiesDict is singleton, use getInstance() to get it.");
            _instance = this;
        }
		
		public static function getInstance():EnemiesDict
		{
			if (!_instance)
				_instance = new EnemiesDict();
			return _instance;
		}
        
        public function get enemies():Vector.<EnemyDescVO>
        {
			if (!_enemies)
			{
                _enemies = new Vector.<EnemyDescVO>();
				
				var src:XML = XML(new source());
				var items:XMLList = src.child(EnemyDescVO.NAME);
				for each (var item:XML in items)
				{
					var event:EnemyDescVO = new EnemyDescVO();
                    event.deserialize(item);
                    _enemies.push(event);
				}
			}
            return _enemies;
        }
		
		/**
		 * Получить информацию по врагу
		 * @param resourceId идентификатор врага
		 * @return информация по врагу
		 */
		public function getEnemy(enemyId:String):EnemyDescVO
		{
			for each (var enemy:EnemyDescVO in enemies)
			{
				if (enemy.enemyId == enemyId)
					return enemy;
			}
			return null;
		}
	}
}