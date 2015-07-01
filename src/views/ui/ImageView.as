package views.ui
{
    import flash.events.Event;
    
    import mx.core.UIComponent;
    
    import managers.ImagesManager;
    import managers.data.IImageClipData;
    import managers.events.ImagesManagerEvent;
    
    [Event(name="complete", type="flash.events.Event")]
    
    /**
     * 
     * @author y.vircowskiy
     * Компонент, работающий с ImageManager-ом
     * 
     */
    
    public class ImageView extends UIComponent
    {
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        private var _imageId:String;
        
        private var _stretch:Object;
        private var _repeat:Object;
        private var _clipData:IImageClipData;
        
        private var _invalid:Boolean;
        
        private var _imageReady:Boolean;
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        public function ImageView()
        {
            super();
        }
        
        /**
         * Идентификатор изображения
         */
        public function set imageId(value:String):void
        {
            if (value == _imageId)
                return;
            
            _imageId = value;
            _imageReady = false;
            
            invalidateDisplayList();
        }
        
        public function get imageId():String
        {
            return _imageId;
        }
        
        /**
         * Масштабировать изображение
         */
        public function set stretch(value:Boolean):void
        {
            if (value == _stretch)
                return;
            
            _stretch = value;
            invalidateDisplayList();
        }
        
        /**
         * Тайлить изображение при масштабировании
         */
        public function set repeat(value:Boolean):void
        {
            if (value == _repeat)
                return;
            
            _repeat = value;
            invalidateDisplayList();
        }
        
        /**
         * Параметры для порезки изображения при растягивании
         */
        public function set clipData(value:IImageClipData):void
        {
            if (value == _clipData)
                return;
            
            _clipData = value;
            invalidateDisplayList();
        }
        
        //--------------------------------------------------------------------------
        //
        //--------------------------------------------------------------------------
        
        /**
         * Обработчик готовности изображения
         * @param event событие
         */
        private function imagesManager_imageReadyComplete(event:ImagesManagerEvent):void
        {
            event.stopImmediatePropagation();
            
            if (event.data.toString() == _imageId)
            {
                removeEventListener(ImagesManagerEvent.IMAGE_READY, imagesManager_imageReadyComplete);
                
                if (ImagesManager.getInstance().paint(_imageId, graphics,
                    unscaledWidth, unscaledHeight, _stretch, _repeat, _clipData))
                {
                    if (!_imageReady)
                    {
                        dispatchEvent(new Event(Event.COMPLETE));
                        _imageReady = true;
                    }
                }
            }
        }
        
        /**
         * Обработчик загрузки библиотек
         * @param event событие
         */
        private function imagesManager_loadingComplete(event:ImagesManagerEvent):void
        {
            event.stopImmediatePropagation();
            
            removeEventListener(ImagesManagerEvent.LOADING_COMPLETE, imagesManager_loadingComplete);
            invalidateDisplayList();
        }
        
        //----------------------------------
        //  UIComponent
        //----------------------------------
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            graphics.clear();
            
            if (!unscaledWidth || !unscaledHeight)
                return;
            
            try {
                if (ImagesManager.getInstance().paint(_imageId, graphics,
                    unscaledWidth, unscaledHeight, _stretch, _repeat, _clipData))
                {
                    if (!_imageReady)
                    {
                        dispatchEvent(new Event(Event.COMPLETE));
                        _imageReady = true;
                    }
                }
                else
                {
                    ImagesManager.getInstance().addEventListener(ImagesManagerEvent.IMAGE_READY, imagesManager_imageReadyComplete);
                }
            }
            catch (e:Error) {
                ImagesManager.getInstance().addEventListener(ImagesManagerEvent.LOADING_COMPLETE, imagesManager_loadingComplete);
            }
        }
    }
}