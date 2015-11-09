package proxy
{
    import dictionary.BasesDict;
    import dictionary.Const;
    
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.BaseTemplVO;
    import vo.EnemiesVO;
    import vo.EnemyVO;
    import vo.PropertyVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси армии
     * 
     */
    
    public class EnemiesProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "enemiesProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EnemiesProxy(data:EnemiesVO=null)
        {
            super(NAME, data);
        }
        
        public function get enemiesVO():EnemiesVO
        {
            return getData() as EnemiesVO;
        }
        
        /**
         * Получить владельца базы
         * @param baseId идентификатор базы
         * @return идентификатор владельца базы, null, если база принадлежит игроку
         */
        public function getOwner(baseId:String):String
        {
            for each (var enemy:EnemyVO in enemiesVO.children)
            {
                for each (var property:PropertyVO in enemy.children)
                {
                    if (property.propertyId == baseId)
                        return enemy.enemyId;
                }
            }
            return null;
        }
        
        /**
         * Получить врага по его идентификатору
         * @param enemyId идентификатор врага, если null, возвращаются данные для анонимуса
         * @return враг
         */
        public function getEnemy(enemyId:String=null):EnemyVO
        {
            for each (var enemy:EnemyVO in enemiesVO.children)
            {
                if (enemy.enemyId == enemyId)
                    return enemy;
            }
            return null;
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:EnemiesVO = appDataProxy.getChildByName(EnemiesVO.NAME) as EnemiesVO;
                
                if (!value)
                {
                    var anonimous:EnemyVO = new EnemyVO();
                    anonimous.enemyId = Const.NO_GUID;
                    
                    var enemies:EnemiesVO = new EnemiesVO();
                    enemies.children.push(anonimous);
                    
                    for each (var baseTempl:BaseTemplVO in BasesDict.getInstance().bases)
                    {
                        var property:PropertyVO = new PropertyVO();
                        property.propertyId = baseTempl.baseId;
                        
                        anonimous.children.push(property);
                    }
                    
                    value = enemies;
                }
                
                setData(value);
                
                appDataProxy.updateChild(enemiesVO);
            }
            
            return data;
        }
    }
}