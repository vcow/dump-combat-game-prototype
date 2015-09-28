package command.data
{
    import vo.PriceVO;

    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на перезарядку
     * 
     */
    
    public class ReloadWeaponCmdData
    {
        public var unitId:String;               //< Идентификатор юнита
        public var slot:Vector.<int>;           //< Слоты перезаряжаемого оружия
        public var ammo:PriceVO;                //< Заряды
        
        public function ReloadWeaponCmdData(unitId:String, slot:Vector.<int>, ammo:PriceVO)
        {
            this.unitId = unitId;
            this.slot = slot;
            this.ammo = ammo;
        }
    }
}