package helpers
{
    import dictionary.BasesDict;
    import dictionary.Const;
    
    import facade.ProtoFacade;
    
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    
    import vo.BaseVO;
    import vo.EnemyVO;
    import vo.PropertyVO;

    /**
     * 
     * @author y.vircowskiy
     * Декоратор вражеской собственности
     * 
     */
    public class PropertyHelper
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _enemiesProxy:EnemiesProxy;
        private var _basesListProxy:BasesListProxy;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PropertyHelper(basesListProxy:BasesListProxy=null, enemiesProxy:EnemiesProxy=null)
        {
            _enemiesProxy = enemiesProxy || EnemiesProxy(ProtoFacade.getInstance().retrieveProxy(EnemiesProxy.NAME));
            _basesListProxy = basesListProxy || BasesListProxy(ProtoFacade.getInstance().retrieveProxy(BasesListProxy.NAME));
        }
        
        public function redistributeProperty(baseId:String=null, ownerId:String=null):void
        {
            var propertyChanged:Boolean;
            
            if (baseId)
            {
                // Одна из баз перешла другому владельцу
                var movProperty:PropertyVO;
                for each (var enemy:EnemyVO in _enemiesProxy.enemiesVO.children)
                {
                    for (var i:int = enemy.children.length - 1; i >= 0; i--)
                    {
                        var property:PropertyVO = PropertyVO(enemy.children[i]);
                        if (property.propertyId == baseId)
                        {
                            if (enemy.enemyId == (ownerId || Const.NO_GUID))
                                return;     // Новый владелец уже является хозяином базы
                            
                            enemy.children.splice(i, 1);
                            movProperty = property;
                            break;
                        }
                    }
                    
                    if (movProperty)
                        break;
                }
                
                var base:BaseVO = _basesListProxy.getBase(baseId) as BaseVO;
                if (base)
                {
                    // База перешла к игроку
                    propertyChanged = movProperty != null;
                }
                else
                {
                    // База перешла к другому врагу
                    enemy = _enemiesProxy.getEnemy(ownerId);
                    
                    if (!enemy)
                        throw Error("Unknown enemy (" + ownerId + ").");
                    
                    if (!movProperty)
                    {
                        if (!BasesDict.getInstance().getBase(baseId))
                            throw Error("Base " + baseId + " does not exist.");
                        
                        movProperty = new PropertyVO();
                        movProperty.propertyId = baseId;
                    }
                    
                    enemy.children.push(movProperty);
                    propertyChanged = true;
                }
            }
            else
            {
                // Изменился список баз у игрока
                // Находим и изымаем у врагов все базы, которые в настоящий момент принадлежат игроку
                var bases:Vector.<BaseVO> = _basesListProxy.getBasesList();
                for each (enemy in _enemiesProxy.enemiesVO.children)
                {
                    for (i = enemy.children.length - 1; i >= 0; i--)
                    {
                        property = PropertyVO(enemy.children[i]);
                        for each (base in bases)
                        {
                            if (property.propertyId == base.baseId)
                            {
                                enemy.children.splice(i, 1);
                                propertyChanged = true;
                                break;
                            }
                        }
                    }
                }
            }
            
            if (propertyChanged)
            {
                // TODO: дернуть соответствующие расчетные триггеры
            }
        }
    }
}