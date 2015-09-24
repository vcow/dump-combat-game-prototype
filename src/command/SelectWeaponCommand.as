package command
{
    import command.data.ReloadCmdData;
    import command.data.SelectWeaponCmdData;
    
    import dictionary.Const;
    
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
            if (data)
            {
                var unit:UnitVO = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME)).getUnit(data.unitId);
                if (!unit)
                    return;
                
                var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                var newWeaponIsTwoHanded:Boolean = false;
                
                var newWeapon:WeaponVO = new WeaponVO();
                newWeapon.weaponId = data.weaponId;
                newWeapon.weaponSlot = data.weaponSlot;
                
                if (newWeapon.weaponDesc)
                {
                    if (!resourcesDecor.isEnoughResources(resourcesDecor.joinResource(newWeapon.weaponDesc.weaponResource, 1)))
                    {
                        // Выбранного оружия нет на складе
                        return;
                    }
                    
                    newWeaponIsTwoHanded = newWeapon.weaponDesc.weaponTwoHanded;
                }
                else
                {
                    newWeapon = null;
                }
                
                for (var i:int = 0; i < unit.children.length; i++)
                {
                    if (unit.children[i].name == WeaponVO.NAME)
                    {
                        var weapon:WeaponVO = WeaponVO(unit.children[i]);
                        if (weapon.weaponSlot == data.weaponSlot || newWeaponIsTwoHanded)
                        {
                            // В этом слоте уже есть оружие
                            
                            if (weapon.weaponId == data.weaponId && (!newWeaponIsTwoHanded || weapon.weaponSlot == data.weaponSlot))
                                return;     // Это то же самое оружие, ничего не меняем
                            
                            // Разрядить и убрать на склад текущее оружие
                            sendNotification(Const.RELOAD_WEAPON, new ReloadCmdData(data.unitId, data.weaponSlot, null));
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.joinResource(weapon.weaponDesc.weaponResource, 1));
                            unit.children.splice(i, 1);
                            
                            if (!newWeaponIsTwoHanded)
                                break;
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