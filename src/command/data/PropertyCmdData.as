package command.data
{
    public class PropertyCmdData
    {
        public var baseId:String;
        public var ownerId:String;
        
        public function PropertyCmdData(baseId:String, ownerId:String=null)
        {
            this.baseId = baseId;
            this.ownerId = ownerId;
        }
    }
}