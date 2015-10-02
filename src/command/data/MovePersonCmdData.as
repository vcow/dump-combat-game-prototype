package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для перевода персонажа на другую базу или новую должность
     * 
     */
    
    public class MovePersonCmdData
    {
        public var personId:String;
        public var baseId:String;
        public var professionId:String;
        
        public function MovePersonCmdData(personId:String, baseId:String, professionId:String=null)
        {
            this.personId = personId;
            this.baseId = baseId;
            this.professionId = professionId;
        }
    }
}