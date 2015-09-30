package command
{
    import command.data.SelectArmamentCmdData;
    
    import dictionary.Const;
    
    import helpers.ConditionHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    
    import vo.ArmorVO;
    import vo.UnitVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Команда на выбор брони для юнита
     * 
     */
    
    public class SelectArmorCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function SelectArmorCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:SelectArmamentCmdData = notification.getBody() as SelectArmamentCmdData;
            if (data && data.armamentSlot.length > 0)
            {
                var unit:UnitVO = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME)).getUnit(data.unitId);
                if (!unit)
                    return;
                
                var resourcesDecor:ResourcesHelper = new ResourcesHelper();
                
                var newArmor:ArmorVO = new ArmorVO();
                newArmor.armorId = data.armamentId;
                newArmor.armorSlot = data.armamentSlot;
                
                if (newArmor.armorDesc)
                {
                    if (!(new ConditionHelper()).parseCondition(newArmor.armorDesc.armorCondition))
                    {
                        // Не выполняется условие использования оружия
                        return;
                    }
                    
                    if (!resourcesDecor.isEnoughResources(resourcesDecor.joinResource(newArmor.armorDesc.armorResource, 1)))
                    {
                        // Выбранного оружия нет на складе
                        return;
                    }
                    
                    if (newArmor.armorDesc.armorSlot.length > 0)
                    {
                        var compareNum:int = data.armamentSlot.length;
                        for each (var slot:int in newArmor.armorDesc.armorSlot)
                        {
                            if (data.armamentSlot.indexOf(slot) >= 0)
                                compareNum--;
                        }
                        
                        if (compareNum != 0)
                        {
                            // Слоты, куда помещается броня, не соответствуют слотам, куда она может быть помещена
                            return;
                        }
                    }
                    else
                    {
                        if (data.armamentSlot.length > 1)
                        {
                            // Броня кладется в несколько слотов, хотя занимает только один
                            return;
                        }
                    }
                }
                else
                {
                    newArmor = null;
                }
                
                for (var i:int = unit.children.length - 1; i >= 0; i--)
                {
                    if (unit.children[i].name == ArmorVO.NAME)
                    {
                        var armor:ArmorVO = ArmorVO(unit.children[i]);
                        
                        compareNum = armor.armorSlot.length;
                        for each (slot in armor.armorSlot)
                        {
                            if (data.armamentSlot.indexOf(slot) >= 0)
                                compareNum--;
                        }
                        
                        if ( compareNum < armor.armorSlot.length)
                        {
                            // В этом слоте уже есть броня
                            
                            if (armor.armorId == data.armamentId && compareNum == 0)
                                return;     // Это та же самая броня, ничего не меняем
                            
                            // Убрать на склад текущую броню
                            sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.joinResource(armor.armorDesc.armorResource, 1));
                            unit.children.splice(i, 1);
                        }
                    }
                }
                
                if (newArmor)
                {
                    sendNotification(Const.CHANGE_RESOURCES, resourcesDecor.joinResource(newArmor.armorDesc.armorResource, -1));
                    unit.children.push(newArmor);
                }
                
                sendNotification(Const.ARMOR_SELECTED, data.unitId);
            }
        }
    }
}