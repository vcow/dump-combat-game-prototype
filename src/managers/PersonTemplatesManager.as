package managers
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    
    import facade.ProtoFacade;
    
    import proxy.PersonsProxy;
    
    import vo.PersonVO;

    /**
     * 
     * @author y.vircowskiy
     * Менеджер шаблонов персонажей
     * 
     */
    
    public class PersonTemplatesManager
    {
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private static var _instance:PersonTemplatesManager;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private static const MIN_UNIQUE:int = 5;
        
        [Embed(source="../../assets/xml/person_names.xml", mimeType="application/octet-stream")]
        private static const namesClass:Class;
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        private var _images:Array = [];
        private var _names:Array = [];
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        public function PersonTemplatesManager()
        {
            if (_instance != null)
                throw Error("PersonTemplatesManager is singleton, use getInstance() to get it.");
            _instance = this;
            
            for each (var desc:XML in describeType(PersonAvatars).constant.(@type == "Class"))
            {
                if (desc.hasOwnProperty("@name"))
                {
                    var name:String = desc.@name.toString();
                    _images.push({
                        name: name,
                        count: 0
                    });
                }
            }
            
            for each (desc in XML(new namesClass()).children())
            {
                _names.push({
                    name: desc.hasOwnProperty("@name") ? desc.@name.toString() : "???",
                    gender: desc.hasOwnProperty("@gender") ? desc.@gender.toString() : "m",
                    count: 0
                });
            }
            
            ImagesManager.getInstance().addAssets(PersonAvatars);
        }
        
        public static function getInstance():PersonTemplatesManager
        {
            if (!_instance)
                _instance = new PersonTemplatesManager();
            return _instance;
        }
        
        /**
         * Получить список данных для новых персонажей, сформированный таким образом,
         * чтобы ранее использовавшиеся аватары и имена встречались там как можно реже
         * @param limit максимальный размер списка
         * @return список данных
         */
        public function getPersonsList(limit:int=0):Array
        {
            var res:Array = [];
            
            var rawNames:Dictionary = new Dictionary(true);
            for each (var item:Object in _names)
                rawNames[item.name] = item;
            
            var rawImages:Dictionary = new Dictionary(true);
            for each (item in _images)
                rawImages[item.name] = item;
            
            var personsProxy:PersonsProxy = PersonsProxy(ProtoFacade.getInstance().retrieveProxy(PersonsProxy.NAME));
            for each (var person:PersonVO in personsProxy.personsVO.children)
            {
                item = rawNames[person.personName];
                if (item)
                    item.count += 1;
                
                item = rawImages[person.personImage];
                if (item)
                    item.count += 1;
            }
            
            _names.sortOn("count", Array.NUMERIC);
            _images.sortOn("count", Array.NUMERIC);
            
            var imgCtr:int = 0;
            for (var i:int = 0; i < _names.length; i++)
            {
                item = _names[i];
                res.push({
                    name: item.name,
                    gender: item.gender,
                    avatar: _images[imgCtr++].name
                });
                
                if (imgCtr >= _images.length)
                    imgCtr = 0;
            }
            
            return res;
        }
    }
}