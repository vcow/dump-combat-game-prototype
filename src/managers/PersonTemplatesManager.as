package managers
{
    import flash.utils.describeType;
    
    import facade.ProtoFacade;
    
    import proxy.AppDataProxy;

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
        
        private var _imagesCtr:Object;
        private var _namesCtr:Object;
        
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
            
            var stuff:Object = AppDataProxy(ProtoFacade.getInstance().retrieveProxy(AppDataProxy.NAME)).stuff;
            
            _imagesCtr = stuff.avatarImagesCount;
            if (!_imagesCtr)
                stuff.avatarImagesCount = _imagesCtr = {};
            
            _namesCtr = stuff.avatarNamesCount;
            if (!_namesCtr)
                stuff.avatarNamesCount = _namesCtr = {};
            
            for each (var desc:XML in describeType(PersonAvatars).constant.(@type == "Class"))
            {
                if (desc.hasOwnProperty("@name"))
                {
                    var name:String = desc.@name.toString();
                    _images.push({
                        name: name,
                        count: _imagesCtr.hasOwnProperty(name) ? int(_imagesCtr[name]) : 0
                    });
                }
            }
            
            _images.sortOn("count", Array.NUMERIC);
            
            for each (desc in XML(new namesClass()).children())
            {
                if (desc.hasOwnProperty("@id"))
                {
                    var id:int = parseInt(desc.@id.toString());
                    _names.push({
                        id: id,
                        name: desc.hasOwnProperty("@name") ? desc.@name.toString() : "???",
                        gender: desc.hasOwnProperty("@gender") ? desc.@gender.toString() : "m",
                        count: _namesCtr.hasOwnProperty(id) ? int(_namesCtr[id]) : 0
                    });
                }
            }
            
            _names.sortOn("count", Array.NUMERIC);
            
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
            
            if (!_images.length || !_names.length)
                return res;
            
            if (!limit)
                limit = Math.max(_images.length, _names.length);
            
            var namesLimit:int = -1;
            var imagesLimit:int = -1;
            
            for (var i:int = 0; i < limit; i++)
            {
                if (namesLimit < 0)
                {
                    if (i < _names.length - 1)
                    {
                        if (_names[i].count > 0 && i >= MIN_UNIQUE - 1)
                            namesLimit = i + 1;
                    }
                    else
                    {
                        namesLimit = _names.length;
                    }
                }
                var limit:int = namesLimit < 0 ? _names.length : namesLimit;
                var nameData:Object = _names[i % limit];
                
                if (imagesLimit < 0)
                {
                    if (i < _images.length - 1)
                    {
                        if (_images[i].count > 0 && i >= MIN_UNIQUE - 1)
                            imagesLimit = i + 1;
                    }
                    else
                    {
                        imagesLimit = _images.length;
                    }
                }
                limit = imagesLimit < 0 ? _images.length : imagesLimit;
                var imageData:Object = _images[i % limit];
                
                res.push({
                    name: nameData.name,
                    gender: nameData.gender,
                    avatar: imageData.name
                });
            }
            
            return res;
        }
        
        /**
         * Юзер выбрал вариант имени и аватара (метод должен вызываться для учета использованных имен и аватаров)
         * @param name выбранное имя
         * @param avatar выбранный аватар
         */
        public function select(name:String, avatar:String):void
        {
            for each (var data:Object in _names)
            {
                if (data.name == name)
                {
                    _namesCtr[data.id] = _namesCtr.hasOwnProperty(data.id) ? int(_namesCtr[data.id]) + 1 : 1;
                    break;
                }
            }
            
            for each (data in _images)
            {
                if (data.name == avatar)
                {
                    _imagesCtr[data.name] = _imagesCtr.hasOwnProperty(data.name) ? int(_imagesCtr[data.name]) + 1 : 1;
                    break;
                }
            }
        }
    }
}