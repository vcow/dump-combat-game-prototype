package command
{
    import org.puremvc.as3.patterns.command.MacroCommand;
    
    /**
     * 
     * @author y.vircowskiy
     * Запущен на выполнение новый квест
     * 
     */
    
    public class QuestStartedCommand extends MacroCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function QuestStartedCommand()
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