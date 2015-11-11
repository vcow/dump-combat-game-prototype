package command.data
{
    import vo.UnitVO;

    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на атаку базы
     * 
     */
    
    public class AttackBaseCmdData
    {
        public var target:String;                   //< База, на которую напали
        public var targetOwner:String;              //< Владелец базы, на которую нападают
        public var departure:String;                //< База, с которой напали
        public var departureOwner:String;           //< Владелец базы, с которой происходит нападение
        public var army:Vector.<UnitVO>             //< Список атакующих юнитов
        
        public function AttackBaseCmdData(target:String, targetOwner:String, departure:String,
                                          departureOwner:String, army:Vector.<UnitVO>)
        {
            this.target = target;
            this.targetOwner = targetOwner;
            this.departure = departure;
            this.departureOwner = departureOwner;
            this.army = army;
        }
    }
}