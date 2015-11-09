package vo
{
    import dictionary.Const;
    import dictionary.EnemiesDict;
    
    /**
     * 
     * @author y.vircowskiy
     * Value Object врага
     * 
     */
    
    public class EnemyVO extends VO
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "enemy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _enemyId:String;
        private var _enemyDesc:EnemyDescVO;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EnemyVO()
        {
            super(NAME);
        }
        
        /**
         * Уникальный идентификатор врага
         */
        public function get enemyId():String
        {
            return _enemyId;
        }
        
        public function set enemyId(value:String):void
        {
            if (value == _enemyId)
                return;
            
            _enemyId = value;
            _enemyDesc = EnemiesDict.getInstance().getEnemy(_enemyId);
        }
        
        /**
         * Описание врага
         */
        public function get enemyDesc():EnemyDescVO
        {
            return _enemyDesc;
        }
        
        //----------------------------------
        //  VO
        //----------------------------------
        
        override protected function getSelfXMLObject():XML
        {
            var res:XML = super.getSelfXMLObject();
            
            // TODO: Сериализовать специфичные поля
            
            res.@id = enemyId || Const.NO_GUID;
            
            // /TODO
            
            return res;
        }
        
        override public function deserialize(data:XML):Boolean
        {
            super.deserialize(data);
            
            // TODO: десериализовать специфичные поля
            
            enemyId = data.hasOwnProperty("@id") ? data.@id.toString() : Const.NO_GUID;
            
            // /TODO
            
            return true;
        }
    }
}