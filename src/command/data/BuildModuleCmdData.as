package command.data
{
    /**
     * 
     * @author y.vircowskiy
     * Данные для постройки нового модуля
     * 
     */
    
    public class BuildModuleCmdData
    {
        public var baseId:String;               //< Идентификатор базы, на которой строится модуль
        public var moduleTypeId:String;           //< Тип строящегося модуля
        
        public function BuildModuleCmdData(baseId:String, moduleTypeId:String)
        {
            this.baseId = baseId;
            this.moduleTypeId = moduleTypeId;
        }
    }
}