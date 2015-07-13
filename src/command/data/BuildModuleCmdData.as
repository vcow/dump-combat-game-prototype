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
        public var moduleTypeId:uint;           //< Тип строящегося модуля
        
        public function BuildModuleCmdData(baseId:String, moduleTypeId:uint)
        {
            this.baseId = baseId;
            this.moduleTypeId = moduleTypeId;
        }
    }
}