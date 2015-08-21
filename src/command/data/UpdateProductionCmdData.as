package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для команды на изменение параметров активного производства
     * 
     */
    
    public class UpdateProductionCmdData
    {
        public var productionId:String;
        public var numEngineers:int;
        public var numProducts:int;
        
        public function UpdateProductionCmdData(productionId:String, numEngineers:int, numProducts:int)
        {
            this.productionId = productionId;
            this.numEngineers = numEngineers;
            this.numProducts = numProducts;
        }
    }
}