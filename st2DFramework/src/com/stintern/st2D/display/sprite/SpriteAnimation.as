package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;
    import com.stintern.st2D.utils.Vector2D;

    public class SpriteAnimation extends Sprite
    {
        private var _playAnimationName:String; //현재 재생중인 애니메이션의 이름
        private var _playAnimationFlowIdx:int; //현재 재생중인 애니메이션의 Frame 인덱스
        private var _delayCnt:int;             //frame delay를 위한 카운트 변수
        private var _isPlaying:Boolean         //지금 재생중인지?
        private var _isFirstUpdate:Boolean     //첫번째 업데이트인지. init을 위해 만든 변수
        private var _basePosition:Vector2D;
        
        public function SpriteAnimation()
        {
            super();

            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
            _isPlaying = false;
            _isFirstUpdate = true;
        }
        
        /**
         * 파일 경로를 이용해서 스프라이트를 생성합니다.  
         * @param path  이미지 경로
         * @param animationNmae 재생할 애니메이션 이름
         * @param onCreated 스프라이트가 생성된 후 불려질 콜백 함수
         * @param onProgress 스프라이트가 생성되는 과정에서 불려질 콜백 함수
         * @param x 스프라이트를 처음에 위치시킬 X 좌표
         * @param y 스프라이트를 처음에 위치시킬 Y 좌표
         */
        public function createAnimationSpriteWithPath(path:String, animationName:String, onCreated:Function, onProgress:Function = null,  x:Number=0, y:Number=0 ):void
        {
            playAnimationName = animationName;
            
            createSpriteWithPath(path, onCreated, onProgress,  x, y );
            _basePosition = new Vector2D(x, y);
        }
        
        /**
         * 배치스프라이트를 이용해서 애니메이션 스프라이트를 생성합니다. 
         * @param batchSprite 사용할 배치스프라이트
         * @param animationName 사용할 애니메이션 이름
         * @param x 초기 X좌표
         * @param y 초기 Y좌표
         */
        public function createAnimationSpriteWithBatchSprite(batchSprite:BatchSprite, animationName:String, x:Number=0, y:Number=0 ):void
        {
            playAnimationName = animationName; 
            
            //재생할 애니메이션의 첫번째 frame 이미지를 매개변수로 전달합니다.
            createSpriteWithBatchSprite(batchSprite, AnimationData.instance.animationData[batchSprite.path]["animation"][animationName].animationFlow[0], x, y);
            _basePosition = new Vector2D(x, y);
        }
        
        /**
         * 스프라이트의 Scale, Rotation, Translation, 애니메이션 동작을 변경합니다. 
         */
        override public function update():void
        {
            //애니메이션이 재생중이면
            if(_isPlaying || _isFirstUpdate)
            {
                //available == true -> 로딩 완료
                if(AnimationData.instance.animationData[path]["available"] == true)
                {
                    _isFirstUpdate = false;
                    
                    //다음 프레임으로 이동
                    var playFrame:AnimationFrame = nextFrame();
                    var firstFrame:AnimationFrame = AnimationData.instance.animationData[path]["frame"][0];
                    //현재 사용중인 스프라이트 시트 이미지. 가로 세로 길이가 필요해서 사용함
                    var currentSpriteImg:Bitmap = AssetLoader.instance.getImageTexture(path);
                    
                    //다음 프레임이 존재할 경우
                    if(playFrame != null)
                    {
                        if(isPlaying){
                            this.position.x = _basePosition.x + Math.abs((playFrame.frameX)- firstFrame.frameX);    
                            this.position.y = _basePosition.y + Math.abs((playFrame.frameY)- firstFrame.frameY);    
                        }
                        
                        //uv좌표 변경하는 방식
                        frame.width = playFrame.width;
                        frame.height = playFrame.height;
                        setUVCoord(playFrame.x/currentSpriteImg.width, playFrame.y/currentSpriteImg.height, playFrame.width/currentSpriteImg.width, playFrame.height/currentSpriteImg.height);
                    }
                    
                    playFrame = null;
                    currentSpriteImg = null;
                }
            }
            
            super.update();
        }
        
        /**
         * 애니메이션을 다음 프레임으로 이동 시킵니다. 
         */
        private function nextFrame():AnimationFrame
        {
            var playAnimation:Animation = getPlayAnimation();
            
            if(_isPlaying)
            {
                //현재 애니메이션 프레임 유지할 경우.
                if(_delayCnt < getDelayNum())
                {
                    _delayCnt++;
                }
                    //유지 시간(pauseFrameCnt)이 다되서 다음 프레임으로 넘어갈 때
                else
                {
                    //FlowIdx 가 0부터 시작이라서 -1을 해줘야 합니다.
                    //아직 다음으로 넘어갈 프레임이 존재하는 경우. 즉 애니메이션이 종료되지 않았을때
                    if(_playAnimationFlowIdx < (playAnimation.animationFlow.length-1))
                    {
                        _delayCnt = 0;
                        _playAnimationFlowIdx++;
                        
                        nextFrame();
                    }
                    //현재 애니메이션이 완료되어 다음 애니메이션으로 넘어가야 할 때
                    else
                    {
                        //다음 애니메이션이 존재할경우
                        if(playAnimation.nextAnimationName != null)
                        {
                            _playAnimationName = playAnimation.nextAnimationName;
                            _delayCnt = 0;
                            _playAnimationFlowIdx = 0;
                            
                            nextFrame();
                        }
                        //다음 애니메이션이 존재하지 않을경우
                        else
                        {
                            isVisible = false;
                            _isPlaying = false;
                            _playAnimationName = null;
                            
                            return null;
                        }
                    }
                }
            }
            //현재 애니메이션의 프레임을 반환합니다.
            return getPlayAnimationFrame();
        }
        
        /**
         * 재생할 애니메이션을 변경합니다.
         * @param name 변경할 애니메이션 이름
         */
        public function setPlayAnimation(name:String):void
        {
            _playAnimationName = name;
            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
        }
        
        /**
         * 애니메이션 재생을 정지합니다. 
         */
        public function pauseAnimation():void
        {
            _isPlaying = false;
        }
        
        /**
         * 애니메이션을 재생합니다. 
         */
        public function playAnimation():void
        {
            if(_playAnimationName != null) _isPlaying = true;
            else trace("먼저 setPlayAnimation을 실행해주세요!");
        }
        
        /**
         * 현재 재생중인 애니메이션의 정보를 Animation 타입으로 반환하는 함수입니다.
         * @return 재생중인 애니메이션의 정보
         */
        private function getPlayAnimation():Animation
        {
            return AnimationData.instance.animationData[path]["animation"][_playAnimationName];
        }
        
        /**
         * 현재 재생중인 애니메이션의 Frame 정보를 AnimationFrame 타입으로 반환하는 함수입니다.
         * @return 재생중인 애니메이션의 현재 Frame
         */
        private function getPlayAnimationFrame():AnimationFrame
        {
            return AnimationData.instance.animationData[path]["frame"][getPlayAnimation().animationFlow[_playAnimationFlowIdx]];
        }
        
        /**
         * 현재 재생중인 애니메이션의 대기 프레임수 입니다.
         * @return 얼마만큼 현재 프레임을 반복해야하는지
         */
        private function getDelayNum():int
        {
            return getPlayAnimation().delayNum;
        }
        
        //get set함수들
        public function get playAnimationName():String {return _playAnimationName;}
        public function get isPlaying():Boolean        {return _isPlaying;}
        
        public function set playAnimationName(value:String):void {_playAnimationName = value;}    
    }
}