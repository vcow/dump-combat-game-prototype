package command
{
    import command.data.ReloadWeaponCmdData;
    
    import dictionary.ArmamentDict;
    import dictionary.Const;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    
    import vo.AmmoDescVO;
    import vo.AmmoVO;
    import vo.PriceVO;
    import vo.ResourceVO;
    import vo.UnitVO;
    import vo.WeaponVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на перезарядку оружия для юнита
     * 
     */
    
    public class ReloadWeaponCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ReloadWeaponCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:ReloadWeaponCmdData = notification.getBody() as ReloadWeaponCmdData;
            if (data)
            {
                var unit:UnitVO = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME)).getUnit(data.unitId);
                if (!unit)
                    return;
                
                for (var i:int = 0; i < unit.children.length; i++)
                {
                    if (unit.children[i].name == WeaponVO.NAME)
                    {
                        var weapon:WeaponVO = WeaponVO(unit.children[i]);
                        
                        var compareNum:int = data.slot.length;
                        for each (var slot:int in weapon.weaponSlot)
                        {
                            if (data.slot.indexOf(slot) >= 0)
                                compareNum--;
                        }
                        
                        if (compareNum == 0)
                        {
                            var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                            var currentLoadedAmmo:PriceVO = new PriceVO();
                            
                            for each (var ammo:AmmoVO in weapon.children)
                                resourcesDecor.joinResource(ammo.ammoDesc.ammoResource, 1, currentLoadedAmmo);
                            
                            if (!data.ammo || data.ammo.children.length == 0)
                            {
                                // Оружие полностью разряжается
                                weapon.children.splice(0, weapon.children.length);
                                
                                if (currentLoadedAmmo.children.length > 0)
                                    sendNotification(Const.CHANGE_RESOURCES, currentLoadedAmmo);    // Вернуть заряды на склад
                                
                                sendNotification(Const.WEAPON_RELOADED, data.unitId);
                                return;
                            }
                            
                            var newAmmo:PriceVO = resourcesDecor.joinPrice(data.ammo, resourcesDecor.invertPrice(currentLoadedAmmo));
                            
                            if (newAmmo.children.length == 0)
                            {
                                // Количество и состав боеприпасов не изменился
                                return;
                            }
                            
                            if (!resourcesDecor.isEnoughResources(resourcesDecor.separatePrice(newAmmo)[0]))
                            {
                                // Не хватает ресурсов для зарядки оружия
                                return;
                            }
                            
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.invertPrice(newAmmo));
                            
                            weapon.children.splice(0, weapon.children.length);
                            
                            for each (var resource:ResourceVO in data.ammo.children)
                            {
                                var ammoDesc:AmmoDescVO = ArmamentDict.getInstance().getAmmoByResource(resource.resourceId);
                                if (!ammoDesc)
                                    continue;
                                
                                for (i = 0; i < resource.resourceCount; i++)
                                {
                                    ammo = new AmmoVO();
                                    ammo.ammoId = ammoDesc.ammoId;
                                    weapon.children.push(ammo);
                                }
                            }
                            
                            sendNotification(Const.WEAPON_RELOADED, data.unitId);
                            break;
                        }
                    }
                }
            }
        }
    }
}