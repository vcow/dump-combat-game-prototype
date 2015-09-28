package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на экипировку боевого юнита
     * 
     */
    
    public class MobilizeUnitCmdData
    {
        public var unitId:String;           //< Идентификатор юнита
        public var name:String;             //< Имя юнита
        public var crew:Vector.<String>;    //< Список идентификаторов членов команды
        public var baseId:String;           //< Идентификатор базы приписки
        
        public function MobilizeUnitCmdData(unitId:String, name:String, crew:Vector.<String>, baseId:String)
        {
            this.unitId = unitId;
            this.name = name;
            this.crew = crew;
            this.baseId = baseId;
        }
    }
}