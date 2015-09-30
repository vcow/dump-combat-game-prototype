package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для команды выбора снаряжения
     * 
     */
    
    public class SelectArmamentCmdData
    {
        public var unitId:String;               //< Идентификатор юнита
        public var armamentSlot:Vector.<int>;   //< Номер слота, куда выбирается снаряжение
        public var armamentId:String;           //< Идентификатор выбираемого снаряжения
        
        public function SelectArmamentCmdData(unitId:String, armamentSlot:Vector.<int>, armamentId:String)
        {
            this.unitId = unitId;
            this.armamentSlot = armamentSlot;
            this.armamentId = armamentId;
        }
    }
}