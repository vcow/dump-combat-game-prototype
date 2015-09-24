package command
{
    import command.data.ReloadCmdData;
    import command.data.SelectWeaponCmdData;
    
    import dictionary.Const;
    
    import helpers.ConditionHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    
    import vo.UnitVO;
    import vo.WeaponVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на выбор оружия для юнита
     * 
     */
    
    public class SelectWeaponCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function SelectWeaponCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:SelectWeaponCmdData = notification.getBody() as SelectWeaponCmdData;
            if (data && data.weaponSlot.length > 0)
            {
                var unit:UnitVO = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME)).getUnit(data.unitId);
                if (!unit)
                    return;
                
                var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                
                var newWeapon:WeaponVO = new WeaponVO();
                newWeapon.weaponId = data.weaponId;
                newWeapon.weaponSlot = data.weaponSlot;
                
                if (newWeapon.weaponDesc)
                {
                    if (!(new ConditionHelper()).parseCondition(newWeapon.weaponDesc.weaponCondition))
                    {
                        // Не выполняется условие использования оружия
                        return;
                    }
                    
                    if (!resourcesDecor.isEnoughResources(resourcesDecor.joinResource(newWeapon.weaponDesc.weaponResource, 1)))
                    {
                        // Выбранного оружия нет на складе
                        return;
                    }
                    
                    if (newWeapon.weaponDesc.weaponSlot.length > 0)
                    {
                        var compareNum:int = data.weaponSlot.length;
                        for each (var slot:int in newWeapon.weaponDesc.weaponSlot)
                        {
                            if (data.weaponSlot.indexOf(slot) >= 0)
                                compareNum--;
                        }
                        
                        if (compareNum != 0)
                        {
                            // Слоты, куда помещается оружие, не соответствуют слотам, куда оно может быть помещено
                            return;
                        }
                    }
                    else
                    {
                        if (data.weaponSlot.length > 1)
                        {
                            // Оружие кладется в несколько слотов, хотя занимает только один
                            return;
                        }
                    }
                }
                else
                {
                    newWeapon = null;
                }
                
                for (var i:int = unit.children.length - 1; i >= 0; i--)
                {
                    if (unit.children[i].name == WeaponVO.NAME)
                    {
                        var weapon:WeaponVO = WeaponVO(unit.children[i]);
                        
                        compareNum = weapon.weaponSlot.length;
                        for each (slot in weapon.weaponSlot)
                        {
                            if (data.weaponSlot.indexOf(slot) >= 0)
                                compareNum--;
                        }
                        
                        if ( compareNum < weapon.weaponSlot.length)
                        {
                            // В этом слоте уже есть оружие
                            
                            if (weapon.weaponId == data.weaponId && compareNum == 0)
                                return;     // Это то же самое оружие, ничего не меняем
                            
                            // Разрядить и убрать на склад текущее оружие
                            sendNotification(Const.RELOAD_WEAPON, new ReloadCmdData(data.unitId, weapon.weaponSlot, null));
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.joinResource(weapon.weaponDesc.weaponResource, 1));
                            unit.children.splice(i, 1);
                        }
                    }
                }
                
                if (newWeapon)
                {
                    sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.joinResource(newWeapon.weaponDesc.weaponResource, -1));
                    unit.children.push(newWeapon);
                }
                
                sendNotification(Const.WEAPON_SELECTED, data.unitId);
            }
        }
    }
}