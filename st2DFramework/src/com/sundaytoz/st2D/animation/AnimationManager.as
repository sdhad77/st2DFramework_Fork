package com.sundaytoz.st2D.animation
{
    import flash.events.Event;
    
    /* 애니메이션 매니져 사용 방법입니다.
    1  initAnimationManager - 매니져 객체 초기화
    2  setAnimationFrame    - 애니메이션 프레임 저장
    3  setAnimation         - 원하는 애니메이션 추가
    4  setPlayAnimation     - 재생하고 싶은 애니메이션 이름 설정
    5  nextFrame            - 다음 frame으로 이동
    6  getFrame             - 이번에 그릴 frame 정보
    5~6 반복
    
    skel.png 파일을 이용한 클래스 사용 예시입니다.
    
    //애니메이션 매니져 생성
    _animation = new AnimationManager();
    
    //애니메이션을 사용할 경우 ,초기화해주는 함수 호출
    _animation.initAnimationManager();
    
    //원하는 애니메이션 자유롭게 설정.  이름              프레임 호출 순서                                                                                         각 프레임 별 대기 시간(프레임) 다음 애니메이션
    _animation.setAnimation("up",    new Array("up0","up1","up2","up1"),             new Array(8,8,8,8), "right");
    _animation.setAnimation("right", new Array("right0","right1","right2","right1"), new Array(8,8,8,8), "down");
    _animation.setAnimation("down",  new Array("down0","down1","down2","down1"),     new Array(8,8,8,8), "left");
    _animation.setAnimation("left",  new Array("left0","left1","left2","left1"),     new Array(8,8,8,8), "up");
    
    //up 애니메이션 시작
    _animation.setPlayAnimation("up");
    
    이후 
    _animation.nextFrame(); 으로 다음 프레임으로 이동시키고,
    _animation.getFrame(); 으로 얻은 animationFrame을 이용해서 화면에 그려주면 됩니다.
    
    애니메이션 프레임은 SpriteSheet와 함께 존재하는 XML파일에서 읽어온 정보들 입니다.
    getFrame 함수를 호출할 때 마다 다음 frame으로 애니메이션이 넘어가는 형태이므로 getFrame 함수는 매 프레임마다 호출되게끔 하여야 합니다.
    getFrame 함수가 반환하는 animationFrame에는 XML파일에서 읽어온 정보가 그대로 저장되어있으니, 반환된 Frame객체를 이용하여 Sprite에 그려주면 됩니다.
    */
    
    /**
     * 여러개의 애니메이션을 관리하는 클래스입니다
     * @author 신동환
     */
    public class AnimationManager
    {
        private var _frameWidth:int;
        private var _frameHeight:int;
        
        private var _animation:Object;
        private var _animationFrame:Object;
        
        private var _nowPlayAnimationName:String;
        private var _nowAnimationFlowIdx:int;
        private var _pauseFrameCnt:int;
        private var _isAvailable:Boolean;
        
        private var xmlLoader:XmlLoader;
        
        /**
         * AnimationManager 생성자 
         */
        public function AnimationManager():void
        {
        }

        /**
         * AnimationManager 초기화 함수
         */
        public function initAnimationManager():void
        {
            _animation = new Object;
            _animationFrame = new Object;
            _frameWidth = 0;
            _frameHeight = 0;
            _isAvailable= false;
            reset();
            
            xmlLoader = new XmlLoader("res/atlas.xml");
            xmlLoader.addEventListener("xmlLoadComplete", xmlLoaderCompleteListener);
            xmlLoader.load();
        }
        
        /**
         * 애니메이션 프레임을 저장하는 함수 
         * @param animationFrame 애니메이션 프레임이 저장되있는 벡터
         */
        public function setAnimationFrame(animationFrame:Object):void
        {
            _animationFrame = animationFrame;
        }
        
        /**
         * 애니메이션을 설정하는 함수 
         * @param name 애니메이션의 이름
         * @param animationFlow 애니메이션 장면의 순서
         * @param framePauseNum 한 장면에서 몇프레임을 소비할 것인지(멈춰있을 것인지)
         * @param nextAnimationName 다음 애니메이션의 이름
         */
        public function setAnimation(name:String, animationFlow:Array, framePauseNum:Array, nextAnimationName:String):void
        {
            _animation[name] = new Animation(name, animationFlow, framePauseNum, nextAnimationName);
        }
        
        /**
         * 플레이할 애니메이션을 설정합니다
         * @param name 재생할 애니메이션의 이름
         */
        public function setPlayAnimation(name:String):void
        {
            //애니메이션 초기화
            reset();
            
            //매개변수로 애니메이션 이름 설정
            _nowPlayAnimationName = name;
            
            if(isAvailable)
            {
                //애니메이션이 그려지는 Sprite의 가로 세로 길이로 사용될것입니다.
                _frameWidth  = _animationFrame[_animation[_nowPlayAnimationName].animationFlow[_nowAnimationFlowIdx]].frameWidth;
                _frameHeight = _animationFrame[_animation[_nowPlayAnimationName].animationFlow[_nowAnimationFlowIdx]].frameHeight;
            }
            else
            {
                _frameWidth = 32;
                _frameHeight = 32;
            }
        }
        
        /**
         * 애니메이션을 처음 상태로 돌립니다. 
         */
        public function reset():void
        {
            //애니메이션의 첫번째 동작으로 설정합니다.
            _nowAnimationFlowIdx = 0;
            
            //프레임 반복 횟수 카운터를 0으로 설정합니다.
            _pauseFrameCnt = 0;
        }
        
        /**
         * 애니메이션을 다음 프레임으로 이동 시킵니다. 
         */
        public function nextFrame():void
        {
            //현재 애니메이션 프레임 유지할 경우.
            if(_pauseFrameCnt < _animation[_nowPlayAnimationName].framePauseNum[_nowAnimationFlowIdx])
            {
                _pauseFrameCnt++;
            }
                //유지 시간(pauseFrameCnt)이 다되서 다음 프레임으로 넘어갈 때
            else
            {
                //FlowIdx 가 0부터 시작이라서 -1을 해줘야 합니다.
                //아직 다음으로 넘어갈 프레임이 존재하는 경우. 즉 애니메이션이 종료되지 않았을때
                if(_nowAnimationFlowIdx < (_animation[_nowPlayAnimationName].animationFlow.length-1))
                {
                    _pauseFrameCnt = 0;
                    _nowAnimationFlowIdx++;
                }
                //현재 애니메이션이 완료되어 다음 애니메이션으로 넘어가야 할 때
                else
                {
                    setPlayAnimation(_animation[_nowPlayAnimationName].nextAnimationName);
                }
                nextFrame();
            }
        }
        
        /**
         * 현재 애니메이션 Frame의 정보를 가져오는 함수입니다.
         * @return Frame 좌표가 저장되어있는 object를 반환합니다.
         */
        public function getFrame():AnimationFrame
        {
            return _animationFrame[_animation[_nowPlayAnimationName].animationFlow[_nowAnimationFlowIdx]];
        }
        
        public function xmlLoaderCompleteListener(event:Event):void
        {
            xmlLoader.removeEventListener("xmlLoadComplete", xmlLoaderCompleteListener);
            setAnimationFrame(xmlLoader.animationFrameObject);
            _isAvailable = true;
        }
        
        public function get frameWidth():int      {return _frameWidth;}
        public function get frameHeight():int     {return _frameHeight;}
        public function get isAvailable():Boolean {return _isAvailable;}
        
        public function set frameWidth(value:int):void      {_frameWidth  = value;}
        public function set frameHeight(value:int):void     {_frameHeight = value;}
        public function set isAvailable(value:Boolean):void {_isAvailable = value;}
    }
}