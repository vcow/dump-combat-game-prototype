package command
{
    import command.data.ReloadItemCmdData;
    import command.data.SelectArmamentCmdData;
    
    import dictionary.Const;
    
    import helpers.ArmyHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.AppDataProxy;
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    
    import vo.ArmorVO;
    import vo.BaseVO;
    import vo.GarrisonVO;
    import vo.IVO;
    import vo.MercenaryVO;
    import vo.PriceVO;
    import vo.UnitVO;
    import vo.WeaponVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на расформирование боевого юнита
     * 
     */
    
    public class DestroyUnitCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function DestroyUnitCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var armyProxy:ArmyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
            var unit:UnitVO = armyProxy.getUnit(notification.getBody().toString());
            if (unit)
            {
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                
                // Разрядить юнит
                sendNotification(Const.RELOAD_UNIT, new ReloadItemCmdData(unit.unitId, null));
                
                for (var i:int = unit.children.length - 1; i >= 0; i--)
                {
                    var item:IVO = unit.children[i];
                    
                    if (item.name == WeaponVO.NAME)
                    {
                        var weapon:WeaponVO = WeaponVO(item);
                        
                        // Разрядить оружие
                        sendNotification(Const.RELOAD_WEAPON, new ReloadItemCmdData(unit.unitId, null, weapon.weaponSlot));
                        
                        // Во избежание эксплойтов, на склад возвращается оружие только из неповрежденного юнита
                        if (unit.unitDamage <= 0)
                            sendNotification(Const.SELECT_WEAPON, new SelectArmamentCmdData(unit.unitId, weapon.weaponSlot, ""));
                    }
                    else if (item.name == ArmorVO.NAME)
                    {
                        var armor:ArmorVO = ArmorVO(item);
                        
                        // Во избежание эксплойтов, на склад возвращается броня только из неповрежденного юнита
                        if (unit.unitDamage <= 0)
                            sendNotification(Const.SELECT_ARMOR, new SelectArmamentCmdData(unit.unitId, armor.armorSlot, ""));
                    }
                }
                
                if (unit.unitDesc.resourceDesc && unit.unitDamage <= 0)
                {
                    // У юнита есть ресурс и юнит не поврежден
                    var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy, appDataProxy);
                    var price:PriceVO = resourcesDecor.joinResource(unit.unitDesc.unitResource, 1);
                    if (resourcesDecor.isEnouchSpace(price))
                    {
                        sendNotification(Const.CHANGE_RESOURCES, price);
                    }
                    else
                    {
                        // Не хватает места на складе для размещения ресурса расформировываемого юнита.
                        // Предполагается, что юзер уже знал об этом и дал добро на утерю ресурса
                    }
                }
                
                // Удалить юнит с базы
                var base:BaseVO = (new ArmyHelper(basesListProxy, appDataProxy, null, armyProxy)).getUnitPlace(unit.unitId);
                var garrison:GarrisonVO = base ? base.baseGarrison : new GarrisonVO();
                for (i = 0; i < garrison.children.length; i++)
                {
                    if (MercenaryVO(garrison.children[i]).mercenaryUnitId == unit.unitId)
                    {
                        garrison.children.splice(i, 1);
                        break;
                    }
                }
                
                // Удалить юнит из армии
                for (i = 0; i < armyProxy.armyVO.children.length; i++)
                {
                    if (UnitVO(armyProxy.armyVO.children[i]).unitId == unit.unitId)
                    {
                        armyProxy.armyVO.children.splice(i, 1);
                        break;
                    }
                }
                
                sendNotification(Const.UNIT_DESTROYED, unit.unitId);
            }
        }
    }
}