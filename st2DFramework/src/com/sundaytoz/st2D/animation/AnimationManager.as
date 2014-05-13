package com.sundaytoz.st2D.animation
{
    /**
     * 여러개의 애니메이션을 관리하는 클래스입니다.<br>
     * 캐릭터 등 애니메이션이 필요한 객체와 하나로 묶어서 사용하면 됩니다.
     * @author 신동환
     */
    public class AnimationManager
    {
        private var _frameWidth:int;
        private var _frameHeight:int;
        private var _rowNum:int;
        private var _colNum:int;
        private var _framePos:Vector.<Object>;
        
        private var _animationInfo:Vector.<Animation>;
        private var _animationNameData:Object;
        private var _animationNameDataCnt:int;
        
        private var _nowPlayAnimationIdx:int;
        private var _nowAnimationFlowIdx:int;
        private var _pauseFrameCnt:int;
        
        /**
         * 애니메이션의 크기와 갯수를 설정합니다.</br>
         * 현재는 애니메이션 Frame들의 크기가 모두 동일하다는 가정하에 이곳에서 크기를 설정하게 하지만, 현재 다른 방식을 이용하도록 수정중입니다
         * @param frameWidth 각 애니메이션 Frame의 가로 길이
         * @param frameHeight 각 애니메이션 Frame의 세로 길이
         * @param rowNum 스프라이트 시트에서 애니메이션 프레임의 행 갯수
         * @param colNum 스프라이트 시트에서 애니메이션 프레임의 열 갯수
         */
        public function AnimationManager(frameWidth:int, frameHeight:int, rowNum:int, colNum:int):void
        {
            _frameWidth = frameWidth;
            _frameHeight = frameHeight;
            _rowNum = rowNum;
            _colNum = colNum;
            
            _framePos = new Vector.<Object>;
            _animationInfo = new Vector.<Animation>;
            _animationNameData = new Object;
            _animationNameDataCnt = 0;
            
            //입력받은 정보들로 스프라이트 시트 상에서 각 이미지들의 위치를 계산합니다.
            calFramePos();
        }

        /**
         * 애니메이션을 초기화합니다. 
         */
        public function reset():void
        {
            //애니메이션의 첫번째 동작으로 설정합니다.
            _nowAnimationFlowIdx = 0;
            _pauseFrameCnt = 0;
        }
        
        /**
         * 입력받은 정보들을 이용해 스프라이트 시트 상에서 각 이미지들의 위치를 계산합니다.
         */
        private function calFramePos():void
        {
            var framePos:Object;
            for(var i:int=0; i < _rowNum; i++)
            {
                for(var j:int=0; j < _colNum; j++)
                {
                    framePos = new Object;
                    framePos.x =  j * _frameWidth;
                    framePos.y =  i * _frameHeight;
                    _framePos.push(framePos);
                }
            }
        }
        
        /**
         * 애니메이션을 설정하는 함수 
         * @param name 애니메이션의 이름
         * @param animationNum 애니메이션의 장면 갯수
         * @param animationFlow 애니메이션 장면의 순서
         * @param framePauseNum 한 장면에서 몇프레임을 소비할 것인지(멈춰있을 것인지)
         * @param nextAnimationName 다음 애니메이션의 이름
         */
        public function setAnimation(name:String, animationNum:int, animationFlow:Array, framePauseNum:Array, nextAnimationName:String):void
        {
            var newAnimationInfo:Animation  = new Animation(name, animationNum, animationFlow, framePauseNum, nextAnimationName);
            _animationNameData[name] = _animationNameDataCnt++;
            _animationInfo.push(newAnimationInfo);
        }
        
        /**
         * 스프라이트 시트 상에서 현재 애니메이션 Frame의 좌표를 가져오는 함수입니다. 
         * @return Frame 좌표가 저장되어있는 object를 반환합니다.
         */
        public function getFramePos():Object
        {
            //현재 애니메이션 프레임 유지할 경우
            if(_pauseFrameCnt < _animationInfo[_nowPlayAnimationIdx].framePauseNum[_nowAnimationFlowIdx])
            {
               _pauseFrameCnt++;
               return _framePos[_animationInfo[_nowPlayAnimationIdx].animationFlow[_nowAnimationFlowIdx]];
            }
            //유지 시간(pauseFrameCnt)이 다되서 다음 프레임으로 넘어갈 때
            else
            {
                //FlowIdx 가 0부터 시작이라서 -1을 해줘야 합니다.
                //아직 다음으로 넘어갈 프레임이 존재하는 경우
                if(_nowAnimationFlowIdx < (_animationInfo[_nowPlayAnimationIdx].animationNum-1)) _nowAnimationFlowIdx++;
                //현재 애니메이션의 마지막 동작까지 마쳐서 다음 동작으로 넘어가야하는 경우.
                //지금은 단순 반복을 하게 하였지만, nextAnimationName을 이용해서 다음 애니메이션으로 이동
                else
                {
                    _nowPlayAnimationIdx = _animationNameData[_animationInfo[_nowPlayAnimationIdx].nextAnimationName];
                    _nowAnimationFlowIdx = 0;
                }

                _pauseFrameCnt = 0;
                
                return getFramePos(); 
            }
            
            return null;
        }
        
        /**
         * 플레이할 애니메이션을 설정합니다.</br>
         * 현재는 int 형으로 매개변수를 받지만 String타입의 애니메이션 이름을 받도록 수정할것입니다.
         * @param value 애니메이션의 인덱스
         */
        public function setPlayAnimation(value:int):void
        {
            reset();
            _nowPlayAnimationIdx = value;
        }
    }
}