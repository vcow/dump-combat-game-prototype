package command.data
{
    import vo.PriceVO;

    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на перезарядку
     * 
     */
    
    public class ReloadItemCmdData
    {
        public var unitId:String;               //< Идентификатор юнита
        public var slot:Vector.<int>;           //< Слоты перезаряжаемого оружия
        public var ammo:PriceVO;                //< Заряды
        
        public function ReloadItemCmdData(unitId:String, ammo:PriceVO, slot:Vector.<int>=null)
        {
            this.unitId = unitId;
            this.slot = slot;
            this.ammo = ammo;
        }
    }
}