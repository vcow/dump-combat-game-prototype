package command
{
    import org.puremvc.as3.patterns.command.MacroCommand;
    
    /**
     * 
     * @author y.vircowskiy
     * Сработал таймер
     * 
     */
    
    public class TimerCompleteCommand extends MacroCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function TimerCompleteCommand()
        {
            super();
        }
        
        //----------------------------------
        //  MacroCommand
        //----------------------------------
        
        override protected function initializeMacroCommand():void
        {
            addSubCommand(CheckRaidsCommand);
        }
    }
}