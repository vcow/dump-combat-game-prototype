package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для команды выбора оружия
     * 
     */
    
    public class SelectWeaponCmdData
    {
        public var unitId:String;           //< Идентификатор юнита
        public var weaponSlot:int;          //< Номер слота, куда выбирается оружие
        public var weaponId:String;         //< Идентификатор выбираемого оружия
        
        public function SelectWeaponCmdData(unitId:String, weaponSlot:int, weaponId:String)
        {
            this.unitId = unitId;
            this.weaponSlot = weaponSlot;
            this.weaponId = weaponId;
        }
    }
}