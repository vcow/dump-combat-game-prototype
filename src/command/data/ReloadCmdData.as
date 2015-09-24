package command.data
{
    import vo.PriceVO;

    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на перезарядку
     * 
     */
    
    public class ReloadCmdData
    {
        public var unitId:String;
        public var slot:int;
        public var ammo:PriceVO;
        
        public function ReloadCmdData(unitId:String, slot:int, ammo:PriceVO)
        {
            this.unitId = unitId;
            this.slot = slot;
            this.ammo = ammo;
        }
    }
}