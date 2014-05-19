package com.stintern.st2D.animation
{
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;
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
        
        // 모든 데이터가 저장되는 Dictionary입니다
        // path(SpriteSheet의 경로)를 key로 하여 이 SpriteSheet와 관련된 모든 정보들을 저장합니다.
        // 이 Dinctionary의 구조는 다음과 같습니다.
        // animationData[path][bitmap] = bitmap
        //                               [frame][frameName] = AnimationFrame
        //                              [animation] = Animation
        //                              [available] = 사용 가능 여부(int type, [0,1 == false][2 == true])
        // available은 xml파일, img 파일등을 읽어 올때 발생하는 비동기 상황 때문에 로딩이 완료된것인지 판별하기 위해 넣었습니다.
        // 현재는 테스트하기 위해 숫자로 넣어놨지만, 문자열로 바꿀 예정입니다.
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
         * 애니메이션을 사용하기 위해 최초로 호출되어야 하는 함수입니다.</br>
         * 이미지 경로와 xml 파일 경로를 이용하여 각각 데이터를 읽어와서 Dictionary에 저장합니다. 
         * @param pathTexture SpriteSheet의 경로
         * @param pathXML SpriteSheet의 Atlas 정보들이 들어있는 xml파일
         */
        public function setAnimationData(pathTexture:String, pathXML:String):void
        {
            //이 path가 아직 key로 등록 되어있지 않다면, 초기화를 해줍니다.
            if(!(pathTexture in _animationData))
            {
                _animationData[pathTexture] = new Dictionary;
                _animationData[pathTexture]["animation"] = new Dictionary;
                _animationData[pathTexture]["available"] = 0;
            }
            
            //이미지를 읽어옵니다.
            AssetLoader.instance.loadImageTexture(pathTexture, onLoadImageTextureComplete);
            
            //xml파일을 읽어옵니다.
            XmlLoader.instance.load(pathXML, onXmlLoaderComplete);
            
            function onLoadImageTextureComplete(object:Object, imageNo:uint):void
            {
                //이미지를 읽어온 후 저장합니다.
                _animationData[pathTexture]["bitmap"] = object as Bitmap;
                //이미지 로딩이 끝났다는 의미에서 변수를 1 증가시킵니다.
                _animationData[pathTexture]["available"]++;
            }
            function onXmlLoaderComplete(dictionary:Dictionary):void
            {
                //xml파일을 읽어온 후 저장합니다.
                _animationData[pathTexture]["frame"] = dictionary;
                //xml파일 로딩이 끝났다는 의미에서 변수를 1 증가시킵니다.
                _animationData[pathTexture]["available"]++;
            }
        }
        
        /**
         * texture의 연결을 해제합니다. 
         * @param pathTexture 해제할 Texture의 경로
         */
        public function removeAnimationTexture(pathTexture:String):void
        {
            if(pathTexture in _animationData)
            {
                _animationData[pathTexture] = null;
            }
            else trace("texture가 존재하지 않습니다");
        }
        
        /**
         * xml 파일을 새로 읽어올 때 사용합니다.
         * @param pathTexture Data Dictionary의 key
         * @param pathXML 새로 읽어올 xml 파일
         */
        public function setAnimationFrame(pathTexture:String, pathXML:String):void
        {
            //path가 key값으로 존재한다면
            if(pathTexture in _animationData)
            {
                _animationData[pathTexture]["available"]--;
                XmlLoader.instance.load(pathXML, onXmlLoaderComplete);
            }
            else trace("texture가 존재하지 않습니다");
            
            function onXmlLoaderComplete(object:Object):void
            {
                _animationData[pathTexture]["frame"] = object;
                _animationData[pathTexture]["available"]++;
            }
        }
        
        /**
         * Xml데이터(frame데이터)를 해제하는 함수입니다.
         * @param pathTexture frame 데이터를 해제하고 싶은 텍스쳐의 경로
         */
        public function removeAnimationFrame(pathTexture:String):void
        {
            if(pathTexture in _animationData)
            {
                _animationData[pathTexture]["frame"] = null;
            }
            else trace("texture가 존재하지 않습니다");
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
         * Dictionary 안의 Data를 전부 지우는 함수입니다.
         */
        public function clearAnimationData():void
        {
            for (var key:* in _animationData) delete _animationData[key];
        }
        
        public function get animationData():Dictionary {return _animationData;}
        
        public function set animationData(value:Dictionary):void {_animationData = value;}
    }
}