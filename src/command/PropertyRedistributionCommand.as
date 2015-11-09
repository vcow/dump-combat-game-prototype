package command
{
    import command.data.PropertyCmdData;
    
    import dictionary.BasesDict;
    import dictionary.Const;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.BasesListProxy;
    import proxy.EnemiesProxy;
    
    import vo.BaseVO;
    import vo.EnemyVO;
    import vo.PropertyVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Произошло перераспределение собственности
     * 
     */
    
    public class PropertyRedistributionCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PropertyRedistributionCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:PropertyCmdData = notification.getBody() as PropertyCmdData;
            var enemiesProxy:EnemiesProxy = EnemiesProxy(this.facade.retrieveProxy(EnemiesProxy.NAME));
            var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
            var propertyChanged:Boolean;
            
            if (data && data.baseId)
            {
                // Одна из баз перешла другому владельцу
                var movProperty:PropertyVO;
                for each (var enemy:EnemyVO in enemiesProxy.enemiesVO.children)
                {
                    for (var i:int = enemy.children.length - 1; i >= 0; i--)
                    {
                        var property:PropertyVO = PropertyVO(enemy.children[i]);
                        if (property.propertyId == data.baseId)
                        {
                            if (enemy.enemyId == (data.ownerId || Const.NO_GUID))
                                return;     // Новый владелец уже является хозяином базы
                            
                            enemy.children.splice(i, 1);
                            movProperty = property;
                            break;
                        }
                    }
                    
                    if (movProperty)
                        break;
                }
                
                var base:BaseVO = basesListProxy.getBase(data.baseId) as BaseVO;
                if (base)
                {
                    // База перешла к игроку
                    propertyChanged = movProperty != null;
                }
                else
                {
                    // База перешла к другому врагу
                    enemy = enemiesProxy.getEnemy(data.ownerId);
                    
                    if (!enemy)
                        throw Error("Unknown enemy (" + data.ownerId + ").");
                    
                    if (!movProperty)
                    {
                        if (!BasesDict.getInstance().getBase(data.baseId))
                            throw Error("Base " + data.baseId + " does not exist.");
                        
                        movProperty = new PropertyVO();
                        movProperty.propertyId = data.baseId;
                    }
                    
                    enemy.children.push(movProperty);
                    propertyChanged = true;
                }
            }
            else
            {
                // Изменился список баз у игрока
                // Находим и изымаем у врагов все базы, которые в настоящий момент принадлежат игроку
                var bases:Vector.<BaseVO> = basesListProxy.getBasesList();
                for each (enemy in enemiesProxy.enemiesVO.children)
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