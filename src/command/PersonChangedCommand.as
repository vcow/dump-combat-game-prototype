package command
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import proxy.PersonsProxy;
    
    import vo.PersonVO;
    
    public class PersonChangedCommand extends SimpleCommand
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonChangedCommand()
        {
            super();
        }
        
        //----------------------------------
        //  SimpleCommand
        //----------------------------------
        
        override public function execute(notification:INotification):void
        {
            var person:PersonVO = notification.getBody() as PersonVO;
            if (person)
            {
                var personsProxy:PersonsProxy = PersonsProxy(this.facade.retrieveProxy(PersonsProxy.NAME));
                personsProxy.updateChild(person);
            }
        }
    }
}