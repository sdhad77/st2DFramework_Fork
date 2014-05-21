package com.stintern.st2D.utils
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    /**
     * Asset 파일들을 불러옵니다. 
     * @author 이종민
     */
    public class AssetLoader
    {
        // 싱글톤 관련 변수들
        private static var _instance:AssetLoader;
        private static var _creatingSingleton:Boolean = false;
        
        // 이미지 Dictionary
        private var _imageMap:Dictionary = new Dictionary(); 
        private var _imageCount:uint = 0;
        
        public function AssetLoader()
        {
            if (!_creatingSingleton){
                throw new Error("[AssetLoader] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():AssetLoader
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new AssetLoader();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        /**
         * 이미 불러온 이미지 파일의 Bitmap 을 반환합니다.
         * @param path 불러올 이미지 경로
         * @return 이미지의 Bitmap 객체
         */
        public function getImageTexture(path:String):Bitmap
        {
            if( path in _imageMap )
            {
                return _imageMap[path];
            }
            
            trace("해당 경로로 저장된 이미지 텍스쳐가 없습니다.");
            return null;
        }
    
    
        /**
         * 경로에 해당하는 이미지 파일을 불러옵니다.  
         * @param path 불러올 이미지 파일의 경로
         * @param onComplete 이미지가 로드되었을 때 불려질 콜백 함수
         * @param onProgress 이미지가 로드될 때 불려질 프로그래스 콜백 함수
         * @example 아래 코드를 참조해서 사용하세요
         * <listing version="3.0">
         * 
         * A.as
         * public function onProgress(event:Object):void{
         *      trace(event as Number);
         * }
         * public function onComplete(event:Object):void{
         *      var bmp:Bitmap = event as Bitmap;
         * }
         * 
         * AssetLoader.instance.loadImageTexture("res/texture.png", onComplete, onProgress);
         * 
         * </listing>
         */
        public function loadImageTexture( path:String, onComplete:Function, onProgress:Function = null ):void
        {
            var imageCount:uint = _imageCount;
            _imageCount++;
            
            // 이미 불러온 이미지가 있을 경우에는 로드하지 않고 바로 보냄
            if( path in _imageMap )
            {
                onComplete(_imageMap[path], imageCount);
                return;
            }
            
            var file:File = findFile(path);
            var fileStream:FileStream = new FileStream(); 
            fileStream.open(file, FileMode.READ);
            
            var bytes:ByteArray = new ByteArray();
            fileStream.readBytes(bytes);
            
            fileStream.close();
            
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            loader.loadBytes(bytes);
                                    
            function onLoaderProgress(event:ProgressEvent):void
            {
                if( onProgress != null )
                {
                    onProgress(event.bytesLoaded/event.bytesTotal * 100);
                }
            }
            
            function onLoaderComplete(event:Event):void
            {
                trace("onLoaderComplete" + path);
                
                onComplete( LoaderInfo(event.target).content as Bitmap, imageCount );
                
                // dictionary 에 불러온 이미지 저장
                _imageMap[path] = LoaderInfo(event.target).content as Bitmap;
                               
            }
            
            function ioErrorHandler(event:IOErrorEvent):void
            {
                trace("Image Load error: " + event.target + " _ " + event.text );                  
            }
        }
        
        public function loadXML(path:String):XML
        {
            var file:File = findFile(path);
            var fileStream:FileStream = new FileStream();
            fileStream.open(file, FileMode.READ);
            
            var xmlNode:XML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
            return xmlNode;
        }
        
        public function loadXMLAsync(path:String, onComplete:Function, onProgress:Function = null):void
        {
            var file:File = findFile(path);
            var fileStream:FileStream = new FileStream(); 
            fileStream.addEventListener(Event.COMPLETE, processXMLData); 
            fileStream.openAsync(file, FileMode.READ); 
            
            function processXMLData(event:Event):void  
            { 
                var xmlNode:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
                fileStream.close(); 
                
                onComplete(xmlNode);
            } 
        }
        
        /**
         * 디바이스 내부 저장소를 확인하여 File 객체를 리턴합니다. 
         */
        private function findFile(path:String):File
        {
            var file:File = File.applicationDirectory.resolvePath(path);
            if( file.exists )
                return file;
            
            file = File.applicationStorageDirectory.resolvePath(path);
            if( file.exists )
                return file;
            
            return null;
        }
        
        /**
         * AssetLoader 에 저장되어 있는 이미지를 삭제하면서 자원을 해제합니다. 
         */
        public function removeImage(path:String):void
        {
            var bmp:Bitmap = _imageMap[path];
            
            var bmpData:BitmapData = (_imageMap[path] as Bitmap).bitmapData;
            if( bmpData != null )
            {
                bmpData.dispose();
            }
            
            _imageMap[path] = null;
        }
        
        public function get imageCount():uint
        {
            return _imageCount;
        }
        
        public function increaseImageNo():uint
        {
            _imageCount++;
            return _imageCount;
        }
      
    }
}