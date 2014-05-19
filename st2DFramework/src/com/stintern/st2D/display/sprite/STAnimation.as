package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;
    import flash.display3D.Context3D;

    public class STAnimation extends STSprite
    {
        private var _playAnimationName:String; //현재 재생중인 애니메이션의 이름
        private var _playAnimationFlowIdx:int; //현재 재생중인 애니메이션의 Frame 인덱스
        private var _delayCnt:int;             //frame delay를 위한 카운트 변수
        private var _isPlaying:Boolean         //지금 재생중인지?
        
        public function STAnimation()
        {
            super();

            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
            _isPlaying = false;
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
            this.path = path;
            
            position.x = x;
            position.y = y;
            
            playAnimationName = animationName;
            
            AssetLoader.instance.loadImageTexture(path, onComplete, onProgress);
            function onComplete(object:Object, zOrder:uint):void
            {
                this.zOrder = zOrder;
                
                initBuffer();
                initTexture((object as Bitmap));
                
                update();
                
                onCreated();
            }
        }

        
        /**
         * 스프라이트 출력에 필요한 버퍼를 초기화합니다. 
         */
        private function initBuffer():void
        {
            var context:Context3D = StageContext.instance.context; 
            
            vertexBuffer = context.createVertexBuffer(vertexData.length/9, 9); 
            vertexBuffer.uploadFromVector(vertexData, 0, vertexData.length/9);
            
            indexBuffer = context.createIndexBuffer(indexData.length);
            indexBuffer.uploadFromVector(indexData, 0, indexData.length);
        }
        
        /**
         * 스프라이트의 Scale, Rotation, Translation, 애니메이션 동작을 변경합니다. 
         */
        override public function update():void
        {
            //전체 애니메이션 업데이트 중지
            if(_isPlaying == false) return;
            
            //0,1 -> 현재 이미지,xml 로딩 중, 2 -> 로딩 완료
            if(AnimationData.instance.animationData[path]["available"] == 2)
            {
                //다음 프레임으로 이동
                var playFrame:AnimationFrame = nextFrame();
                
                //uv좌표 변경하는 방식
                frame.width = playFrame.width;
                frame.height = playFrame.height;
                setUVCoord(playFrame.x/textureWidth, playFrame.y/textureHeight, playFrame.width/textureWidth, playFrame.height/textureHeight);
                
                playFrame = null;
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
                            _delayCnt = 0;
                            _playAnimationFlowIdx = 0;
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
            _isPlaying = true;
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
        
        public function set playAnimationName(value:String):void {_playAnimationName = value;}    
    }
}