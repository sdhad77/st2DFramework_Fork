package com.stintern.st2D.animation
{
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.utils.AssetLoader;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.utils.Dictionary;
    
    /**
     * 애니메이션과 관련된 모든 정적 정보들을 저장하는 클래스입니다.</br>
     * 여기서 정적이라 함은, 현재 재생중인 애니메이션의 정보와 같이 매 프레임마다 바뀌는 값이 아닌</br>
     * SpriteSheet, 애니메이션 frame의 x,y, width, height 등을 의미합니다. 
     * @author 신동환
     */
    public class AnimationData
    {
        // 싱글톤 관련 변수들
        private static var _instance:AnimationData;
        private static var _creatingSingleton:Boolean = false;
        
        // 모든 BatchSprite의 이미지 관련 정보가 저장되는 Dictionary입니다.
        // path(SpriteSheet의 경로)를 key로 하여 정보를 저장합니다.
        // 이 Dinctionary의 구조는 BatchSprite의 이미지내에 이미지가 하나만 존재하는지, 여러개 존재하는지에 따라
        // 구조가 둘로 나뉘게 되며, 이미지내에 이미지가 여러개 존재할 경우의 예시는 다음과 같습니다.
        // animationData[path]["frame"][frameName]         = AnimationFrame
        //                    ["animation"][animationName] = Animation
        //                    ["available"]                = 사용 가능 여부(int type, [0,1 == false][2 == true])
        //                    ["type"]                     = 이 Dictionary의 타입(int type, [0 == 단일 이미지][1 == 복수의 이미지])
        //
        // 다음은 이미지내에 이미지가 하나만 존재 할 경우의 구조 예시 입니다.
        // animationData[path]["type"]                     = Dictionary의 타입(int type, [0 == 단일 이미지][1 == 복수의 이미지])
        // 
        private var _animationData:Dictionary = new Dictionary;
        private var _sch:Scheduler = new Scheduler;
        
        public function AnimationData()
        {
            if (!_creatingSingleton){
                throw new Error("[AnimationData] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():AnimationData
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new AnimationData();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        /**
         * 단일 이미지를 가지는 BatchSprite에서 사용할 dictionary를 생성합니다.
         * @param path 이 Dictionary를 사용할 이미지의 경로
         */
        public function createDictionary(path:String):void
        {
            if(!(path in _animationData))
            {
                //path를 키로 하는 Dictionayr 초기화
                _animationData[path] = new Dictionary;
                _animationData[path]["type"] = 0;
            }
        }
        
        /**
         * 애니메이션 정보들을 저장할 수 있는 Dictionary를 생성하고 초기화 하는 함수입니다.
         * @param path 이 Dictionary를 사용할 이미지의 경로
         * @param pathXML 이 Dictionary에서 사용할 Frame정보들이 있는 xml 파일 경로
         * @param onCreated 이미지파일,xml파일 로딩이 끝났을때 호출할 콜백 함수
         */
        public function createAnimationDictionary(path:String, pathXML:String, onCreated:Function):void
        {
            //애니메이션 정보가 아직 등록되지않은 path 일 경우
            if(!(path in _animationData))
            {
                //path를 키로 하는 Dictionayr 초기화
                _animationData[path] = new Dictionary;
                _animationData[path]["animation"] = new Dictionary;
                _animationData[path]["type"] = 1;
                _animationData[path]["available"] = false;
                _animationData[path]["xml"] = false;
                _animationData[path]["image"] = false;
                
                //xml파일을 읽어옵니다.
                AssetLoader.instance.loadXML(pathXML, onXmlLoadComplete);
            }
            else if(_animationData[path]["available"] == false)
            {
                trace("로딩중입니다.");
                _sch.addFunc(0, onCreated, 1);
            }
            //이미 애니메이션 정보가 있는 path일 경우
            else
            {
                if(onCreated != null) onCreated();
            }
            
            function onXmlLoadComplete(xml:XML):void
            {
                //xml파일을 읽어온 후 저장합니다.
                _animationData[path]["frame"] = createAnimationFrameDictionary(xml);
                //xml파일 로딩이 끝났다는 의미에서 변수를 1 증가시킵니다.
                _animationData[path]["xml"] = true;
                
                //모든 로딩이 종료 되었으면 콜백함수를 호출합니다.
                if( _animationData[path]["image"] == true )
                {
                    _animationData[path]["available"] = true;
                    if(onCreated != null) onCreated();
                    _sch.startScheduler();
                }  
            }
        }
        
        /**
         * 특정 sprite sheet 이미지의 애니메이션 정보를 삭제하는 함수입니다.</br>
         * 내부의 상세한 데이터들도 null을 하도록 보완해야 합니다.
         * @param path 애니메이션 정보를 삭제할 spriteSheet의 경로
         */
        public function removeAnimationDictionary(path:String):void
        {
            if(path in _animationData)
            {
                _animationData[path]["frame"] = null;
                _animationData[path]["animation"] = null;
                _animationData[path]["available"] = null;
                _animationData[path] = null;
                delete _animationData[path];
            }
            else trace("존재하지 않는 AnimationDictionary에 대한 삭제 시도입니다.");
        }
        
        /**
         * 애니메이션을 새로 추가하는 함수입니다. 
         * @param pathTexture 애니메이션을 추가할 경로(SpriteSheet)
         * @param animation 추가할 애니메이션
         */
        public function setAnimation(pathTexture:String, animation:Animation):void
        {
            if(pathTexture in _animationData)
            {
                if(_animationData[pathTexture]["animation"][animation.name] == null) _animationData[pathTexture]["animation"][animation.name] = animation;
                else trace("Animation이 이미 존재합니다 : " + pathTexture + " : " + animation.name);
            }
            else trace("texture가 존재하지 않습니다");
        }
        
        /**
         * 특정 애니메이션을 해제하는 함수입니다. 
         * @param pathTexture 특정 애니메이션을 지우고 싶은 경로(SpriteSheet)
         * @param animationName 해제될 애니메이션의 이름
         */
        public function removeAnimation(pathTexture:String, animationName:String):void
        {
            if(pathTexture in _animationData)
            {
                if(_animationData[pathTexture]["animation"][animationName] != null) _animationData[pathTexture]["animation"][animationName] = null;
                else trace("Animation이 이미 존재하지 않습니다" + pathTexture + " : " + animationName);
            }
            else trace("texture가 존재하지 않습니다");
        }
        
        /**
         * Dictionary 안의 Data를 전부 지우는 함수입니다.</br>
         * 내부의 상세한 데이터들도 null을 하도록 보완해야 합니다.
         */
        public function clearAnimationData():void
        {
            for (var key:* in _animationData) delete _animationData[key];
        }
        
        private function createAnimationFrameDictionary(xml:XML):Dictionary
        {
            var nameList:XMLList = xml.child("atlasItem").attribute("name");
            var xList:XMLList = xml.child("atlasItem").attribute("x");
            var yList:XMLList = xml.child("atlasItem").attribute("y");
            var widthList:XMLList = xml.child("atlasItem").attribute("width");
            var heightList:XMLList = xml.child("atlasItem").attribute("height");
            var frameXList:XMLList = xml.child("atlasItem").attribute("frameX");
            var frameYList:XMLList = xml.child("atlasItem").attribute("frameY");
            var frameWidthList:XMLList = xml.child("atlasItem").attribute("frameWidth");
            var frameHeightList:XMLList = xml.child("atlasItem").attribute("frameHeight");
            
            var animationFrameDictionary:Dictionary = new Dictionary();
            for(var i:uint = 0; i<xml.children().length(); i++)
            {
                var fileName:String = nameList[i];
                fileName = fileName.substr(0, fileName.indexOf("."));
                
                trace("fileName : " + fileName);
                animationFrameDictionary[fileName] = new AnimationFrame(fileName, xList[i], yList[i], widthList[i], heightList[i], frameXList[i], frameYList[i], frameWidthList[i], frameHeightList[i]);
            }
            
            return animationFrameDictionary;
        }
        
        //get set 함수입니다.
        public function get animationData():Dictionary {return _animationData;}
    }
}