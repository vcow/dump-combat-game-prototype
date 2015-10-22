package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на атаку базы
     * 
     */
    
    public class AttackBaseCmdData
    {
        public var target:String;                   //< База, на которую напали
        public var departure:String;                //< База, с которой напали
        public var army:Vector.<String>             //< Список ID атакующих юнитов
        
        public function AttackBaseCmdData(target:String, departure:String, army:Vector.<String>)
        {
            this.target = target;
            this.departure = departure;
            this.army = army;
        }
    }
}