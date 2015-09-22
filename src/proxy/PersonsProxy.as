package proxy
{
    import org.puremvc.as3.patterns.proxy.Proxy;
    
    import vo.IVO;
    import vo.PersonVO;
    import vo.PersonsVO;
    
    /**
     * 
     * @author y.vircowskiy
     * Прокси игровых персонажей
     * 
     */
    
    public class PersonsProxy extends Proxy
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public static const NAME:String = "personsProxy";
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonsProxy(data:PersonsVO=null)
        {
            super(NAME, data);
        }
        
        public function get personsVO():PersonsVO
        {
            return getData() as PersonsVO;
        }
        
        /**
         * Получить информацию по персонажу
         * @param personId идентификатор персонажа
         * @return персонаж
         */
        public function getPerson(personId:String):PersonVO
        {
            for each (var value:PersonVO in personsVO.children)
            {
                if (value.personId == personId)
                    return value;
            }
            return null;
        }
        
        /**
         * Обновить информацию в дочернем Value Object
         * @param child VO обновляемого персонажа
         */
        public function updatePerson(child:IVO):void
        {
            var person:PersonVO = child as PersonVO;
            if (person)
            {
                for (var i:int = 0; i < personsVO.children.length; i++)
                {
                    var value:PersonVO = PersonVO(personsVO.children[i]);
                    if (value.personId == person.personId)
                    {
                        personsVO.children.splice(i, 1);
                        break;
                    }
                }
                
                personsVO.children.push(person);
            }
        }
        
        //----------------------------------
        //  Proxy
        //----------------------------------
        
        override public function getData():Object
        {
            if (!data)
            {
                var appDataProxy:AppDataProxy = AppDataProxy(this.facade.retrieveProxy(AppDataProxy.NAME));
                var value:PersonsVO = appDataProxy.getChildByName(PersonsVO.NAME) as PersonsVO;
                
                if (!value)
                    value = new PersonsVO();
                
                setData(value);
                
                appDataProxy.updateChild(personsVO);
            }
            
            return data;
        }
    }
}