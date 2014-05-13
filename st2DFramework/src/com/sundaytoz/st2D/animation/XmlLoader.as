package com.sundaytoz.st2D.animation
{
    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    /**
     * 
     * @author 구현모
     * XML파일을 Load하여 animationFrame으로 구성된 animationFrameObject을 반환합니다.
     * XML파일은 <atlasItem name="" x="" y="" width="" height="" frameX="" frameY="" frameWidth="" frameHeight="" />
     * 의 구조로 작성되어야 함.
     * XmlLoader(xmlPath)로 생성하며 XmlLoader.animationFrameObject로 반환됩니다.
     * 
     */
    public class XmlLoader
    {
        private var _xml:XML = new XML();
        private var myLoader:URLLoader;
        private var _animationFrameObject:Object = new Object();
        
        public function XmlLoader(xmlPath:String)
        {
            var myXMLURL:URLRequest = new URLRequest(xmlPath); 
            myLoader = new URLLoader(); 
            
            
            myLoader.addEventListener(Event.COMPLETE, xmlLoaded);
            myLoader.addEventListener(ProgressEvent.PROGRESS, xmlLoading);
            myLoader.load(myXMLURL);
        }
        
        private function xmlLoaded(event:Event):void 
        { 
            _xml = XML(myLoader.data);
            creageAnimationFrameObject();
        }
        
        private function xmlLoading(event:Event):void 
        { 
            trace("loading");
        }
        
        private function creageAnimationFrameObject():void
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
                animationFrameObject[fileName] = new AnimationFrame(fileName, xList[i], yList[i], widthList[i], heightList[i], frameXList[i], frameYList[i], frameWidthList[i], frameHeightList[i]);
                
            }
        }
        
        
        /**
         * @return animationFrame이 저장되어 있는 animationFrameObject를 반환합니다.
         */
        public function get animationFrameObject():Object
        {
            return _animationFrameObject;
        }

    }
}