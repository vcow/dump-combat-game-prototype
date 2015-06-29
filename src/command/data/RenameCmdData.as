package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные команды на переименование
     * 
     */
    
    public class RenameCmdData
    {
        public var renamedObjectId:String;
        public var newObjectName:String;
        
        public function RenameCmdData(renamedObjectId:String=null, newObjectName:String=null)
        {
            this.renamedObjectId = renamedObjectId;
            this.newObjectName = newObjectName;
        }
    }
}