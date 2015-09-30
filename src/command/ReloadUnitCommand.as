package command
{
    import command.data.ReloadItemCmdData;
    
    import dictionary.ArmamentDict;
    import dictionary.Const;
    
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    
    import vo.AmmoDescVO;
    import vo.AmmoVO;
    import vo.IVO;
    import vo.PriceVO;
    import vo.ResourceVO;
    import vo.UnitVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на перезарядку юнита
     * 
     */
    
    public class ReloadUnitCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function ReloadUnitCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:ReloadItemCmdData = notification.getBody() as ReloadItemCmdData;
            if (data)
            {
                var unit:UnitVO = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME)).getUnit(data.unitId);
                if (!unit)
                    return;
                
                var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                var currentLoadedAmmo:PriceVO = new PriceVO();
                
                for each (var item:IVO in unit.children)
                {
                    if (item.name == AmmoVO.NAME)
                    {
                        var ammo:AmmoVO = AmmoVO(item);
                        resourcesDecor.joinResource(ammo.ammoDesc.ammoResource, 1, currentLoadedAmmo);
                    }
                }
                
                if (!data.ammo || data.ammo.children.length == 0)
                {
                    // Юнит полностью разряжается
                    for (var i:int = unit.children.length - 1; i >= 0; i--)
                    {
                        if (unit.children[i].name == AmmoVO.NAME)
                            unit.children.splice(i, 1);
                    }
                    
                    if (currentLoadedAmmo.children.length > 0)
                        sendNotification(Const.CHANGE_RESOURCES, currentLoadedAmmo);    // Вернуть заряды на склад
                    
                    sendNotification(Const.UNIT_RELOADED, data.unitId);
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
                
                for (i = unit.children.length - 1; i >= 0; i--)
                {
                    if (unit.children[i].name == AmmoVO.NAME)
                        unit.children.splice(i, 1);
                }
                
                for each (var resource:ResourceVO in data.ammo.children)
                {
                    var ammoDesc:AmmoDescVO = ArmamentDict.getInstance().getAmmoByResource(resource.resourceId);
                    if (!ammoDesc)
                        continue;
                    
                    for (i = 0; i < resource.resourceCount; i++)
                    {
                        ammo = new AmmoVO();
                        ammo.ammoId = ammoDesc.ammoId;
                        unit.children.push(ammo);
                    }
                }
                
                sendNotification(Const.UNIT_RELOADED, data.unitId);
            }
        }
    }
}