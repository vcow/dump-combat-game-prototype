package command.data
{
    import vo.PersonVO;

    /**
     * 
     * @author y.vircowskiy
     * Данные для создания/перевода нового
     * 
     */
    
    public class HirePersonCmdData
    {
        public var person:PersonVO;
        public var baseId:String;
        public var professionId:uint;
        
        public function HirePersonCmdData(person:PersonVO, baseId:String, professionId:uint)
        {
            this.person = person;
            this.baseId = baseId;
            this.professionId = professionId;
        }
    }
}