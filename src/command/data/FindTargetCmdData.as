package command.data
{
    public class FindTargetCmdData
    {
        public var baseId:String;
        public var ownerId:String;
        
        public function FindTargetCmdData(baseId:String, ownerId:String=null)
        {
            this.baseId = baseId;
            this.ownerId = ownerId;
        }
    }
}