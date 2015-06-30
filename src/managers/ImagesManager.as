package managers
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    
    import managers.data.IImageClipData;
    import managers.data.ImageData;
    import managers.events.ImagesManagerEvent;
    
    [Event(name="loadingBegin", type="managers.events.ImagesManagerEvent")]
    [Event(name="loadingComplete", type="managers.events.ImagesManagerEvent")]
    [Event(name="loadingError", type="managers.events.ImagesManagerEvent")]
    [Event(name="imageReady", type="managers.events.ImagesManagerEvent")]
    
    /**
     * 
     * @author y.vircowskiy
     * Менеджер изображений
     * 
     */
    
    final public class ImagesManager extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        private static var _instance:ImagesManager;
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        private var _imgData:Dictionary = new Dictionary();
        private var _bitmaps:Dictionary = new Dictionary(true);
        
        private var _loaders:Dictionary = new Dictionary();
        private var _isLoading:Boolean;
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        /**
         * Конструктор
         */
        public function ImagesManager()
        {
            if (_instance != null)
                throw Error("ImagesManager is singleton, use getInstance() to get it.");
            _instance = super(null);
        }
        
        public static function getInstance():ImagesManager
        {
            if (!_instance)
                _instance = new ImagesManager();
            return _instance;
        }
        
        /**
         * Добавить данные для изображения
         * @param data данные
         * @return добавленные данные
         */
        public function setImageData(data:ImageData):ImageData
        {
            _imgData[data.id] = data;
            return data;
        }
        
        /**
         * Добавить изображения
         * @param assets класс со встроенными ресурсами изображений
         * @return true, если объект добавлен успешно
         */
        public function addAssets(assets:Class):Boolean
        {
            var classes:XMLList = describeType(assets).constant.(@type == "Class");
            for each (var cls:XML in classes)
            {
                if (!cls.hasOwnProperty("@name"))
                    continue;
                
                var id:String = cls.@name.toString();
                
                var data:ImageData = ImageData(_imgData[id]);
                if (!data)
                    data = setImageData(new ImageData(id));
                
                data.imgClass = assets[id] as Class;
            }
            return true;
        }
        
        /**
         * Загрузить изображения из внешней библиотеки
         * @param url адрес библиотеки
         * @param className имя класса
         */
        public function loadAssets(url:String, className:String=null):void
        {
            var loader:URLLoader = createURLLoader(loadAssetsHandler, loadAssetsHandler, className);
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.load(new URLRequest(url));
        }
        
        /**
         * Загрузить изображение из внеш
         * @param url URL изображения
         * @param id идентификатор, который будет присвоен изображению по окончании загрузки
         */
        public function loadImage(url:String, id:String):void
        {
            var imgData:ImageData = ImageData(_imgData[id]);
            if (imgData)
            {
                if (imgData.url == url)
                {
                    if (_bitmaps[id])
                        return;                                                         // Уже загружено
                    
                    for each (var data:Object in _loaders)
                    {
                        if (data.hasOwnProperty("data") && data.data == id)
                            return;                                                     // Уже в процессе загрузки
                    }
                }
            }
            else
            {
                imgData = setImageData(new ImageData(id));
            }
            
            imgData.url = url;
            
            var loader:Loader = createLoader(loadImageHandler, loadImageHandler, id);
            loader.load(new URLRequest(url));
        }
        
        /**
         * Признак того, что в данный момент происходит загрузка данных
         */
        public function get isLoading():Boolean
        {
            return _isLoading;
        }
        
        /**
         * Получить параметры порезки для изображения
         * @param id идентификатор изображения
         * @return параметры порезки для изображения
         */
        public function getImgClipData(id:String):IImageClipData
        {
            var imgData:ImageData = ImageData(_imgData[id]);
            return imgData ? imgData.imgClipData : null;
        }
        
        /**
         * Отрисовать изображение/заливку
         * @param id идентификатор изображения или заливки
         * @param graphics графический объект для отрисовки
         * @param width размер изображения по ширине, если NaN, то соответствует ширине изображения
         * @param height размер изображения по высоте, если NaN, то соответствует высоте изображения
         * @param stretch растягивать изображение
         * @param repeat тайлить изображение при растягивании
         * @param clipData переопределенные параметры для порезки изображения
         * @return true, если отрисовка выполнена успешно
         */
        public function paint(id:String, graphics:Graphics, width:Number=NaN, height:Number=NaN,
                              stretch:Object=null, repeat:Object=null, clipData:IImageClipData=null):Boolean
        {
            var imgData:ImageData = ImageData(_imgData[id]);
            
            if (!imgData)
                throw Error("Image Manager has not data for [" + id + "].");
            
            graphics.clear();
            
            var bitmapData:BitmapData = getBitmapData(id);
            if (bitmapData)
            {
                stretch = stretch == null ? imgData.stretch : Boolean(stretch);
                repeat = repeat == null ? imgData.repeat : Boolean(repeat);
                clipData = clipData == null ? imgData.imgClipData : clipData;
                
                width = isNaN(width) ? bitmapData.width : width;
                height = isNaN(height) ? bitmapData.height : height;
                
                if (width <= 0 || height <= 0)
                    return true;
                
                if (stretch)
                {
                    var cd:IImageClipData = imgData.imgClipData;
                    var matrix:Matrix = new Matrix();
                    
                    if (cd.left && cd.top)
                    {
                        graphics.beginBitmapFill(bitmapData, matrix, false, true);
                        graphics.drawRect(0, 0, cd.left, cd.top);
                        graphics.endFill();
                    }
                    
                    if (cd.right && cd.top)
                    {
                        matrix.tx = width - bitmapData.width;
                        graphics.beginBitmapFill(bitmapData, matrix, false, true);
                        graphics.drawRect(width - cd.right, 0, cd.right, cd.top);
                        graphics.endFill();
                    }
                    
                    if (cd.left && cd.bottom)
                    {
                        matrix.tx = 0;
                        matrix.ty = height - bitmapData.height;
                        graphics.beginBitmapFill(bitmapData, matrix, false, true);
                        graphics.drawRect(0, height - cd.bottom, cd.left, cd.bottom);
                        graphics.endFill();
                    }
                    
                    if (cd.right && cd.bottom)
                    {
                        matrix.tx = width - bitmapData.width;
                        matrix.ty = height - bitmapData.height;
                        graphics.beginBitmapFill(bitmapData, matrix, false, true);
                        graphics.drawRect(width - cd.right, height - cd.bottom, cd.right, cd.bottom);
                        graphics.endFill();
                    }
                    
                    if (repeat)
                    {
                        var srcRc:Rectangle = new Rectangle();
                        var destRc:Rectangle = new Rectangle();
                        
                        var fillDestRc:Function = function():void {
                            if (destRc.width <= 0 || destRc.height <= 0)
                                return;
                            
                            var fillRc:Rectangle = new Rectangle();
                            
                            var destWidth:Number;
                            var destHeight:Number = destRc.height;
                            do {
                                matrix.ty = destRc.y - srcRc.y + destRc.height - destHeight;
                                fillRc.y = destRc.y + destRc.height - destHeight;
                                fillRc.height = Math.min(destHeight, srcRc.height);
                                
                                destWidth = destRc.width;
                                do {
                                    matrix.tx = destRc.x - srcRc.x + destRc.width - destWidth;
                                    fillRc.x = destRc.x + destRc.width - destWidth;
                                    fillRc.width = Math.min(destWidth, srcRc.width);
                                    
                                    graphics.beginBitmapFill(bitmapData, matrix, false, true);
                                    graphics.drawRect(fillRc.x, fillRc.y, fillRc.width, fillRc.height);
                                    graphics.endFill();
                                    
                                    destWidth -= srcRc.width;
                                } while (destWidth > 0);
                                
                                destHeight -= srcRc.height;
                            } while (destHeight > 0);
                        }
                        
                        if (cd.top)
                        {
                            srcRc.x = cd.left;
                            srcRc.width = bitmapData.width - (cd.left + cd.right);
                            srcRc.height = cd.top;
                            
                            destRc.x = cd.left;
                            destRc.width = width - (cd.left + cd.right);
                            destRc.height = cd.top;
                            
                            fillDestRc();
                        }
                        
                        if (cd.bottom)
                        {
                            srcRc.x = cd.left;
                            srcRc.y = bitmapData.height - cd.bottom;
                            srcRc.width = bitmapData.width - (cd.left + cd.right);
                            srcRc.height = cd.bottom;
                            
                            destRc.x = cd.left;
                            destRc.y = height - cd.bottom;
                            destRc.width = width - (cd.left + cd.right);
                            destRc.height = cd.bottom;
                            
                            fillDestRc();
                        }
                        
                        if (cd.left)
                        {
                            srcRc.x = 0;
                            srcRc.y = cd.top;
                            srcRc.width = cd.left;
                            srcRc.height = bitmapData.height - (cd.top + cd.bottom);
                            
                            destRc.x = 0;
                            destRc.y = cd.top;
                            destRc.width = cd.left;
                            destRc.height = height - (cd.top + cd.bottom);
                            
                            fillDestRc();
                        }
                        
                        if (cd.right)
                        {
                            srcRc.x = bitmapData.width - cd.right;
                            srcRc.y = cd.top;
                            srcRc.width = cd.right;
                            srcRc.height = bitmapData.height - (cd.top + cd.bottom);
                            
                            destRc.x = width - cd.right;
                            destRc.y = cd.top;
                            destRc.width = cd.right;
                            destRc.height = height - (cd.top + cd.bottom);
                            
                            fillDestRc();
                        }
                        
                        srcRc.x = cd.left;
                        srcRc.y = cd.top;
                        srcRc.width = bitmapData.width - (cd.left + cd.right);
                        srcRc.height = bitmapData.height - (cd.top + cd.bottom);
                        
                        destRc.x = cd.left;
                        destRc.y = cd.top;
                        destRc.width = width - (cd.left + cd.right);
                        destRc.height = height - (cd.top + cd.bottom);
                        
                        fillDestRc();
                    }
                    else
                    {
                        var sx:Number = (width - (cd.left + cd.right)) / (bitmapData.width - (cd.left + cd.right));
                        var sy:Number = (height - (cd.top + cd.bottom)) / (bitmapData.height - (cd.top + cd.bottom));
                        
                        if (cd.top)
                        {
                            matrix.scale(sx, 1.0);
                            matrix.tx = cd.left - cd.left * sx;
                            matrix.ty = 0;
                            graphics.beginBitmapFill(bitmapData, matrix, false, true);
                            graphics.drawRect(cd.left, 0, width - (cd.left + cd.right), cd.top);
                            graphics.endFill();
                        }
                        
                        if (cd.bottom)
                        {
                            matrix.a = 1.0;
                            matrix.scale(sx, 1.0);
                            matrix.tx = cd.left - cd.left * sx;
                            matrix.ty = height - bitmapData.height;
                            graphics.beginBitmapFill(bitmapData, matrix, false, true);
                            graphics.drawRect(cd.left, height - cd.bottom, width - (cd.left + cd.right), cd.bottom);
                            graphics.endFill();
                        }
                        
                        if (cd.left)
                        {
                            matrix.a = 1.0;
                            matrix.scale(1.0, sy);
                            matrix.tx = 0;
                            matrix.ty = cd.top - cd.top * sy;
                            graphics.beginBitmapFill(bitmapData, matrix, false, true);
                            graphics.drawRect(0, cd.top, cd.left, height - (cd.top + cd.bottom));
                            graphics.endFill();
                        }
                        
                        if (cd.right)
                        {
                            matrix.a = 1.0;
                            matrix.d = 1.0;
                            matrix.scale(1.0, sy);
                            matrix.tx = width - bitmapData.width;
                            matrix.ty = cd.top - cd.top * sy;
                            graphics.beginBitmapFill(bitmapData, matrix, false, true);
                            graphics.drawRect(width - cd.right, cd.top, cd.right, height - (cd.top + cd.bottom));
                            graphics.endFill();
                        }
                        
                        matrix.a = 1.0;
                        matrix.d = 1.0;
                        matrix.scale(sx, sy);
                        matrix.tx = cd.left - cd.left * sx;
                        matrix.ty = cd.top - cd.top * sy;
                        graphics.beginBitmapFill(bitmapData, matrix, false, true);
                        graphics.drawRect(cd.left, cd.top, width - (cd.left + cd.right), height - (cd.top + cd.bottom));
                        graphics.endFill();
                    }
                }
                else
                {
                    width = Math.min(width, bitmapData.width);
                    height = Math.min(height, bitmapData.height);
                    
                    graphics.beginBitmapFill(bitmapData, null, false);
                    graphics.drawRect(0, 0, width, height);
                    graphics.endFill();
                }
                
                return true;
            }
            
            return false;
        }
        
        //--------------------------------------------------------------------------
        // 
        //--------------------------------------------------------------------------
        
        /**
         * Обработчик загрузки библиотеки изображений
         * @param event событие
         */
        private function loadAssetsHandler(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);
            
            if (event.type == Event.COMPLETE)
            {
                var proxy:Loader = createLoader(loadAssetsProxyHandler, loadAssetsProxyHandler, getLoaderData(loader));
                proxy.loadBytes(loader.data);
            }
            else
            {
                dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_ERROR, event["text"]));
            }
        }
        
        /**
         * Завершена обработка загруженной библиотеки
         * @param event событие
         */
        private function loadAssetsProxyHandler(event:Event):void
        {
            var loader:Loader = Loader(event.target.loader);
            
            if (event.type == Event.COMPLETE)
            {
                var data:Object = getLoaderData(loader);
                var className:String = data ? data.toString() : "";
                
                var name:String = className || String(describeType(event.target.content).@name).replace("::", ".");
                try {
                    var cls:Class = event.target.applicationDomain.getDefinition(name) as Class;
                    addAssets(cls);
                    loader.unload();
                }
                catch (e:Error) {
                    dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_ERROR, e.message));
                }
            }
            else
            {
                dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_ERROR, event["text"]));
            }
        }
        
        /**
         * Обработчик загрузки изображения
         * @param event событие
         */
        private function loadImageHandler(event:Event):void
        {
            var loader:Loader = Loader(event.target.loader);
            var id:String = getLoaderData(loader).toString();
            var imgData:ImageData = ImageData(_imgData[id]);
            
            if (event.type == Event.COMPLETE)
            {
                var bitmap:Bitmap = event.target.content as Bitmap;
                loader.unload();
                
                if (bitmap)
                {
                    if (imgData)
                    {
                        var bitmapData:BitmapData = bitmap.bitmapData;
                        _bitmaps[bitmapData] = id;
                        
                        imgData.imgClipData.width = bitmapData.width;
                        imgData.imgClipData.height = bitmapData.height;
                    }
                }
                else
                {
                    dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_ERROR, imgData.url + " not an image."));
                    if (imgData)
                        imgData.url = null;
                }
            }
            else
            {
                dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_ERROR, event["text"]));
            }
            
            dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.IMAGE_READY, id));
        }
        
        //--------------------------------------------------------------------------
        // Helpers
        //--------------------------------------------------------------------------
        
        /**
         * Получить изображение для указанного идентификатора
         * @param id идентификатор изображения
         * @return изображение, или null, если отсутствует класс
         */
        private function getBitmapData(id:String):BitmapData
        {
            var bitmapData:BitmapData;
            
            for (var key:Object in _bitmaps)
            {
                if (_bitmaps[key] == id)
                {
                    bitmapData = key as BitmapData;
                    if (bitmapData)
                        return bitmapData;
                    break;
                }
            }
            
            var imgData:ImageData = ImageData(_imgData[id]);
            if (imgData)
            {
                if (imgData.imgClass != null)
                {
                    var bitmap:Bitmap = new imgData.imgClass() as Bitmap;
                    if (bitmap)
                    {
                        bitmapData = bitmap.bitmapData;
                        _bitmaps[bitmapData] = id;
                        
                        imgData.imgClipData.width = bitmapData.width;
                        imgData.imgClipData.height = bitmapData.height;
                    }
                }
                else if (imgData.url)
                {
                    loadImage(imgData.url, id);
                }
            }
            return bitmapData;
        }
        
        /**
         * Вспомогательная функция, создает загрузчик
         * @param successHandler обработчик успешного завершения загрузки вида function(event:Event):void
         * @param errorHandler обработчик ошибки загрузки вида function(event:Event):void
         * @param data дополнительные данные
         * @return созданный загрузчик
         */
        private function createURLLoader(successHandler:Function, errorHandler:Function, data:Object=null):URLLoader
        {
            var loader:URLLoader = new URLLoader();
            _loaders[loader] = { successHandler: successHandler, errorHandler: errorHandler, data: data };
            
            if (!_isLoading)
            {
                _isLoading = true;
                dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_BEGIN));
            }
            
            loader.addEventListener(Event.COMPLETE, urlLoaderHandler, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderHandler, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderHandler, false, 0, true);
            
            return loader;
        }
        
        /**
         * Обработчик завершения загрузки контента
         * @param event событие
         */
        private function urlLoaderHandler(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);
            var data:Object = _loaders[loader];
            
            loader.removeEventListener(Event.COMPLETE, urlLoaderHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderHandler);
            
            if (data)
            {
                var handler:Function;
                if (event.type == Event.COMPLETE)
                    handler = data.successHandler as Function;
                else
                    handler = data.errorHandler as Function;
                
                if (handler != null)
                    handler(event);
                
                delete _loaders[loader];
            }
            
            for each (data in _loaders)
                return;
            
            _isLoading = false;
            dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_COMPLETE));
        }
        
        /**
         * Вспомогательная функция, создает proxy-загрузчик для преобразования загруженного контента
         * @param successHandler обработчик успешного завершения загрузки вида function(event:Event):void
         * @param errorHandler обработчик ошибки загрузки вида function(event:Event):void
         * @param data дополнительные данные
         * @return созданный загрузчик
         */
        private function createLoader(successHandler:Function, errorHandler:Function, data:Object=null):Loader
        {
            var loader:Loader = new Loader();
            _loaders[loader] = { successHandler: successHandler, errorHandler: errorHandler, data: data };
            
            if (!_isLoading)
            {
                _isLoading = true;
                dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_BEGIN));
            }
            
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderHandler, false, 0, true);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderHandler, false, 0, true);
            
            return loader;
        }
        
        /**
         * Обработчик завершения работы proxy-загрузчика
         * @param event событие
         */
        private function loaderHandler(event:Event):void
        {
            var loader:Loader = Loader(event.target.loader);
            var data:Object = _loaders[loader];
            
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderHandler);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderHandler);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderHandler);
            
            if (data)
            {
                var handler:Function;
                if (event.type == Event.COMPLETE)
                    handler = data.successHandler as Function;
                else
                    handler = data.errorHandler as Function;
                
                if (handler != null)
                    handler(event);
                
                delete _loaders[loader];
            }
            
            for each (data in _loaders)
                return;
            
            _isLoading = false;
            dispatchEvent(new ImagesManagerEvent(ImagesManagerEvent.LOADING_COMPLETE));
        }
        
        /**
         * Вспомогательная функция, возвращает дополнительные данные, ассоциированные с загрузчиком
         * @param loader загрузчик
         * @return данные, ассоциированные с загрузчиком
         */
        private function getLoaderData(loader:Object):Object
        {
            var data:Object = _loaders[loader];
            return data ? data.data : null;
        }
    }
}