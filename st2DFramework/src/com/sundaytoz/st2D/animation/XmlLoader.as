package com.sundaytoz.st2D.animation
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import com.sundaytoz.st2D.animation.datatype.AnimationFrame;

    /**
     * 
     * @author 구현모
     * XML파일을 Load하여 animationFrame으로 구성된 animationFrameDictionary을 반환합니다.
     * XML파일은 <atlasItem name="" x="" y="" width="" height="" frameX="" frameY="" frameWidth="" frameHeight="" />
     * 의 구조로 작성되어야 함.
     * load(xmlPath onComplete) 호출로 Xml파일을 가져옵니다. load 완료 후에 실행될 구문을 onComplete에 구현합니다. 
     * XmlLoader.animationFrameDictionary을 통해 반환됩니다.
     */
    public class XmlLoader
    {
        
        private static var _instance:XmlLoader;
        private static var _creatingSingleton:Boolean = false;
        
        private var _xml:XML = new XML();
        private var _animationFrameDictionary:Dictionary = new Dictionary();
        
        /**
         * @param xmlPath Xml문서 Path
         * @example  XmlLoader.instance.load("./res/atlas.xml", onComplete);
         *   
         *           function onComplete(dictionary:Dictionary):void
         *           {
         *           }
         */
        public function XmlLoader()
        {
            if (!_creatingSingleton){
                throw new Error("[XmlLoader] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():XmlLoader
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new XmlLoader();
                _creatingSingleton = false;
            }
            return _instance;
        }        

        /**
         * 
         * @param xmlPath Xml파일의 경로.
         * @param onComplete Xml파일이 로드되었을 때 불려질 콜백 함수
         * @param onProgress Xml파일이 로드될 때 불려질 콜백 함수
         * 
         */
        public function load(xmlPath:String, onComplete:Function, onProgress:Function = null):void 
        { 
            var myXmlURL:URLRequest = new URLRequest(xmlPath); 
            var xmlLoader:URLLoader = new URLLoader();
            xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
            xmlLoader.addEventListener(ProgressEvent.PROGRESS, xmlLoadProgress);
            xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            
            xmlLoader.load(myXmlURL);
            
            
            function xmlLoadComplete(event:Event):void 
            { 
                xmlLoader.removeEventListener(ProgressEvent.PROGRESS, xmlLoadProgress);
                xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
                xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                
                _xml = XML(xmlLoader.data);
                createAnimationFrameDictionary();
                
                onComplete(_animationFrameDictionary as Dictionary);
            }
            
            function xmlLoadProgress(event:ProgressEvent):void
            {
                if( onProgress != null )
                {
                    onProgress(event.bytesLoaded/event.bytesTotal * 100);
                }
            }
            
            function ioErrorHandler(event:IOErrorEvent):void
            {
                xmlLoader.removeEventListener(ProgressEvent.PROGRESS, xmlLoadProgress);
                xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
                xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                
                trace("Xml Load error: " + event.target + " _ " + event.text );                  
            }
        }
        
        private function createAnimationFrameDictionary():void
        {
            var nameList:XMLList = _xml.child("atlasItem").attribute("name");
            var xList:XMLList = _xml.child("atlasItem").attribute("x");
            var yList:XMLList = _xml.child("atlasItem").attribute("y");
            var widthList:XMLList = _xml.child("atlasItem").attribute("width");
            var heightList:XMLList = _xml.child("atlasItem").attribute("height");
            var frameXList:XMLList = _xml.child("atlasItem").attribute("frameX");
            var frameYList:XMLList = _xml.child("atlasItem").attribute("frameY");
            var frameWidthList:XMLList = _xml.child("atlasItem").attribute("frameWidth");
            var frameHeightList:XMLList = _xml.child("atlasItem").attribute("frameHeight");
            
            for(var i:uint = 0; i<_xml.children().length(); i++)
            {
                var fileName:String = nameList[i];
                fileName = fileName.substr(0, fileName.indexOf("."));
                
                trace("fileName : " + fileName);
                _animationFrameDictionary[fileName] = new AnimationFrame(fileName, xList[i], yList[i], widthList[i], heightList[i], frameXList[i], frameYList[i], frameWidthList[i], frameHeightList[i]);
            }
        }
        
        /**
         * Instance를 초기화합니다.
         */
        public function clearInstance():void 
        { 
            _instance = null;
            _creatingSingleton = false;
            _xml = new XML();
            _animationFrameDictionary = new Dictionary();
        
        }
        
        /**
         * @return animationFrame이 저장되어 있는 animationFrameDictionary를 반환합니다.
         */
        public function get animationFrameDictionary():Dictionary
        {
            return _animationFrameDictionary;
        }

    }
}