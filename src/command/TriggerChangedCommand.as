package command
{
    import org.puremvc.as3.patterns.command.MacroCommand;
    
    /**
     * 
     * @author y.vircowskiy
     * Обработка изменения значения триггера
     * 
     */
    
    public class TriggerChangedCommand extends MacroCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function TriggerChangedCommand()
        {
            super();
        }
        
        //--------------------------------------------------------------------------
        // MacroCommand
        //--------------------------------------------------------------------------
        
        override protected function initializeMacroCommand():void
        {
            addSubCommand(CheckQuestsCommand);
        }
    }
}