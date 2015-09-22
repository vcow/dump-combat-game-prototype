package command
{
    import command.data.EquipUnitCmdData;
    import command.data.MovePersonCmdData;
    
    import dictionary.Const;
    import dictionary.UnitsDict;
    
    import helpers.ModulesHelper;
    import helpers.ResourcesHelper;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.ArmyProxy;
    import proxy.BasesListProxy;
    import proxy.PersonsProxy;
    
    import vo.BaseVO;
    import vo.EmployeeVO;
    import vo.GarrisonVO;
    import vo.MercenaryVO;
    import vo.ModuleDescVO;
    import vo.PersonVO;
    import vo.PriceVO;
    import vo.ProfessionDescVO;
    import vo.ResourceVO;
    import vo.UnitDescVO;
    import vo.UnitVO;
    import vo.VO;
    
    /**
     * 
     * @author y.vircowskiy
     * Экипировать боевой юнит
     * 
     */
    
    public class EquipUnitCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function EquipUnitCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var data:EquipUnitCmdData = notification.getBody() as EquipUnitCmdData;
            if (data)
            {
                var unitDesc:UnitDescVO = UnitsDict.getInstance().getUnit(data.unitId);
                if (!unitDesc)
                    return;
                
                var basesListProxy:BasesListProxy = BasesListProxy(this.facade.retrieveProxy(BasesListProxy.NAME));
                var resourcesDecor:ResourcesHelper = new ResourcesHelper(basesListProxy);
                
                var price:PriceVO = new PriceVO();
                if (unitDesc.unitResource)
                {
                    var resource:ResourceVO = new ResourceVO();
                    resource.resourceId = unitDesc.unitResource;
                    resource.resourceCount = 1;
                    
                    price.children.push(resource);
                    if (!resourcesDecor.isEnoughResources(price))
                    {
                        // Нет в наличии ресурса юнита
                        // TODO: отправить на докупку ресурсов
                        sendNotification(Const.OPEN_SHOP, notification);
                        return;
                    }
                }
                
                var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
                
                var rawCrew:Vector.<String> = data.crew.slice();
                var sideEmployes:Vector.<PersonVO> = new Vector.<PersonVO>();
                
                var crew:Vector.<EmployeeVO> = new Vector.<EmployeeVO>();
                for each (var base:BaseVO in basesListProxy.getBasesList())
                {
                    for each (var employee:EmployeeVO in base.basePersonnel.children)
                    {
                        var person:PersonVO = personsProxy.getPerson(employee.employeePersonId);
                        
                        for (var i:int = 0; i < rawCrew.length; i++)
                        {
                            if (rawCrew[i] == employee.employeePersonId)
                            {
                                if (person.personProfessionId == ProfessionDescVO.SOLGIER)
                                {
                                    crew.push(employee);
                                    
                                    if (base.baseId != data.baseId)
                                        sideEmployes.push(person);
                                }
                                
                                rawCrew.splice(i, 1);
                                break;
                            }
                        }
                        
                        if (rawCrew.length <= 0)
                            break;
                    }
                    
                    if (rawCrew.length <= 0)
                        break;
                }
                
                if (crew.length < data.crew.length)
                {
                    // Не найдены какие-то из солдат, или же какие-то члены команды не являются солдатами
                    // TODO: хз как на это реагировать, пока - никак
                    return;
                }
                
                base = basesListProxy.getBase(data.baseId) as BaseVO;
                
                if (!base)
                    return;
                
                if (sideEmployes.length > 0)
                {
                    // Есть солдаты, которые переводятся с других баз
                    
                    if ((new ModulesHelper(basesListProxy)).getSpace(ModuleDescVO.HOUSING, base) < sideEmployes.length)
                    {
                        // На базе не хватает жилых модулей для приема новых солдат
                        // TODO: хз что с этим делать, пока ничего
                        return;
                    }
                    
                    for each (person in sideEmployes)
                        sendNotification(Const.MOVE_PERSON, new MovePersonCmdData(person.personId, base.baseId, person.personProfessionId));
                }
                
                if (price.children.length > 0)
                    resourcesDecor.pay(price);      // Забрать со склада боевую машину
                
                var unit:UnitVO = new UnitVO();
                unit.unitId = VO.createGUID();
                unit.unitName = data.name;
                unit.unitUnitId = data.unitId;
                unit.unitCrew = data.crew ? data.crew.slice() : new Vector.<String>();
                unit.unitDamage = 0;
                
                var armyProxy:ArmyProxy = ArmyProxy(this.facade.retrieveProxy(ArmyProxy.NAME));
                armyProxy.armyVO.children.push(unit);
                
                var garrison:GarrisonVO = base.baseGarrison;
                if (!garrison)
                {
                    garrison = new GarrisonVO();
                    base.children.push(garrison);
                }
                
                var mercenary:MercenaryVO = new MercenaryVO();
                mercenary.mercenaryUnitId = unit.unitId;
                
                garrison.children.push(mercenary);
                
                sendNotification(Const.UNIT_IS_EQUIPPED, unit.unitId);
            }
        }
    }
}