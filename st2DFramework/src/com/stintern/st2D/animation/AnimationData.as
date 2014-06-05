package com.stintern.st2D.animation
{
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.utils.Dictionary;
    
    /**
     * 애니메이션과 관련된 모든 정적 정보들을 저장하는 클래스입니다.</br>
     * 여기서 정적이라 함은, 현재 재생중인 애니메이션의 정보와 같이 매 프레임마다 바뀌는 값이 아닌</br>
     * 애니메이션 재생정보, 애니메이션 frame의 x,y, width, height 등을 의미합니다. 
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
        //                    ["available"]                = 이 데이터들의 로딩 완료 여부, xml,이미지 파일로딩이 완료되면 true로 바꿔줍니다.
        //                    ["type"]                     = 이 Dictionary의 타입(int type, [0 == 단일 이미지][1 == 복수의 이미지])
        //
        // 다음은 이미지내에 이미지가 하나만 존재 할 경우의 구조 예시 입니다.
        // animationData[path]["type"]                     = Dictionary의 타입(int type, [0 == 단일 이미지][1 == 복수의 이미지])
        //                    ["available"]                = 이 데이터들의 로딩 완료 여부, 이미지 파일로딩이 완료되면 true로 바꿔줍니다.
        // 
        private var _animationData:Dictionary = new Dictionary;
        
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
                _animationData[path]["available"] = false;
            }
        }
        
        /**
         * 애니메이션 정보들을 저장할 수 있는 Dictionary를 생성하고 초기화 하는 함수입니다.
         * @param path 이 Dictionary를 사용할 이미지의 경로
         * @param pathXML 이 Dictionary에서 사용할 Frame정보들이 있는 xml 파일 경로
         * @param auto 애니메이션을 자동으로 등록할 것인지 여부
         */
        public function createAnimationDictionary(path:String, pathXML:String, auto:Boolean):void
        {
            //애니메이션 정보가 아직 등록되지않은 path 일 경우
            if(!(path in _animationData))
            {
                var xml:XML = AssetLoader.instance.loadXML(pathXML);
                
                //path를 키로 하는 Dictionayr 초기화
                _animationData[path] = new Dictionary;
                _animationData[path]["type"] = 1;
                _animationData[path]["available"] = false;
                _animationData[path]["frame"] = createAnimationFrame(xml);
                
                //애니메이션을 자동으로 등록
                if(auto) _animationData[path]["animation"] = createAnimation(xml);
                else _animationData[path]["animation"] = new Dictionary;
                
                xml = null;
            }
            //아직 로딩중인경우
            else if(_animationData[path]["available"] == false)
            {
                trace("로딩중입니다.");
            }
            //이미 애니메이션 정보가 있는 path일 경우
            else
            {
                trace("이미 존재하는 path입니다.");
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
         * 애니메이션을 새로 추가하는 함수입니다. 
         * @param pathTexture 애니메이션을 추가할 경로(SpriteSheet)
         * @param pathXML 애니메이션이 저장되어있는 xml
         * @param animationName 추가할 애니메이션 이름
         */
        public function setAnimationAuto(pathTexture:String, pathXML:String, animationName:String):void
        {
            if(pathTexture in _animationData)
            {
                if(_animationData[pathTexture]["animation"][animationName] == null)
                {
                    var xml:XML = AssetLoader.instance.loadXML(pathXML);
                    _animationData[pathTexture]["animation"][animationName] = createSelectAnimation(xml, animationName);
                    if(_animationData[pathTexture]["animation"][animationName] == null) trace("존재하지 않는 animationName 입니다.");
                }
                else trace("Animation이 이미 존재합니다 : " + pathTexture + " : " + animationName);
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
         * 특정 애니메이션의 지속시간(각 frame별 유지시간)을 설정하는 함수입니다.
         * @param path 스프라이트 시트의 경로
         * @param animationName 지속시간을 변경할 애니메이션 이름
         * @param delayNum 변경할 지속시간(프레임)
         */
        public function setAnimationDelayNum(path:String, animationName:String, delayNum:int):void
        {
            _animationData[path]["animation"][animationName].delayNum = delayNum;
        }
        
        /**
         * Dictionary 안의 Data를 전부 지우는 함수입니다.</br>
         * 내부의 상세한 데이터들도 null을 하도록 보완해야 합니다.
         */
        public function clearAnimationData():void
        {
            for (var key:* in _animationData) delete _animationData[key];
        }
        
        private function createAnimationFrame(xml:XML):Dictionary
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
                animationFrameDictionary[fileName] = new AnimationFrame(fileName, xList[i], yList[i], widthList[i], heightList[i], frameXList[i], frameYList[i], frameWidthList[i], frameHeightList[i]);
            }
            
            return animationFrameDictionary;
        }
        
        /**
         * xml 파일에서 name 정보를 이용해서 애니메이션 Frame 순서를 만드는 함수입니다.</br>
         * xml에서 name -> Animation이름_FrameNumber.png 의 구조로 이루어져 있습니다.
         * @param xml 스프라이트 시트의 xml파일
         * @return Animation 객체들이 저장된 Dictionary
         */
        private function createAnimation(xml:XML):Dictionary
        {
            var nameList:XMLList = xml.child("atlasItem").attribute("name");
            var aniName:String;
            var frameName:String;
            
            var animationDictionary:Dictionary = new Dictionary();
            var nameDictionary:Dictionary = new Dictionary();
            var aniNameArray:Array = new Array;
            
            //애니메이션 순서를 저장하는 곳
            for(var i:uint = 0; i<xml.children().length(); i++)
            {
                aniName = nameList[i].substr(0, nameList[i].indexOf("_"));
                
                frameName = nameList[i].substr(0, nameList[i].indexOf("."));
                
                if(!(aniName in nameDictionary))
                {
                    nameDictionary[aniName] = new Array;
                    nameDictionary[aniName].push(frameName);
                    aniNameArray.push(aniName);
                }
                else nameDictionary[aniName].push(frameName);
            }
            
            //animation 객체 생성
            for(i=0; i<aniNameArray.length; i++)
            {
                animationDictionary[aniNameArray[i]] = new Animation(aniNameArray[i], nameDictionary[aniNameArray[i]], 1);
            }
            
            //메모리 해제
            while(aniNameArray.length > 0) aniNameArray.pop();
            for (var key:* in nameDictionary) delete nameDictionary[key];
            key = null;
            nameDictionary = null;
            
            return animationDictionary;
        }
        
        /**
         * xml 파일에서 특정 애니메이션의 Frame 순서를 만드는 함수입니다.</br>
         * xml에서 name -> Animation이름_FrameNumber.png 의 구조로 이루어져 있습니다.
         * @param xml 스프라이트 시트의 xml파일
         * @param animationName 읽어올 특정 애니메이션의 이름
         * @return 새로 만든 Animation 객체
         */
        private function createSelectAnimation(xml:XML, animationName:String):Animation
        {
            var nameList:XMLList = xml.child("atlasItem").attribute("name");
            var frameName:String;
            
            var animation:Animation;
            var animationFlow:Array;
            
            //애니메이션 순서를 저장하는 곳
            for(var i:uint = 0; i<xml.children().length(); i++)
            {
                if(animationName != nameList[i].substr(0, nameList[i].indexOf("_"))) continue;
                
                frameName = nameList[i].substr(0, nameList[i].indexOf("."));
                
                if(animationFlow == null)
                {
                    animationFlow = new Array;
                    animationFlow.push(frameName);
                }
                else animationFlow.push(frameName);
            }
            
            //animation 객체 생성
            if(animationFlow != null) animation = new Animation(animationName, animationFlow, 1);
            
            //메모리 해제
            animationFlow = null;
            frameName = null;
            nameList = null;
            
            return animation;
        }
        
        //get set 함수입니다.
        public function get animationData():Dictionary {return _animationData;}
    }
}