package command.data
{
    /**
     * 
     * @author y.vircowskiy
     *  Данные для удаления модуля
     * 
     */
    
    public class RemoveModuleCmdData
    {
        public var baseId:String;               //< Идентификатор базы
        public var moduleTypeId:String;           //< Идентификатор типа удаляемого модуля
        public var moduleIndex:uint;            //< Индекс удаляемого модуля
        
        public function RemoveModuleCmdData(baseId:String, moduleTypeId:String, moduleIndex:uint)
        {
            this.baseId = baseId;
            this.moduleTypeId = moduleTypeId;
            this.moduleIndex = moduleIndex;
        }
    }
}