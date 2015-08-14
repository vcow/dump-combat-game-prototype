package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на изменение параметров активного исследования
     * 
     */
    
    public class UpdateResearchCmdData
    {
        public var researchId:String;
        public var numScientists:int;
        
        public function UpdateResearchCmdData(researchId:String, numScientists:int)
        {
            this.researchId = researchId;
            this.numScientists = numScientists;
        }
    }
}