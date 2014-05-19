package com.stintern.st2D.animation.datatype
{
    import flash.utils.Dictionary;

    /**
     * 애니메이션 재생 정보를 저장하는 클래스입니다. 
     * @author 신동환
     */
    public class AnimationPlayData
    {   
        private var _animationData:Dictionary; //AnimationData의 Dictionary 중 하나
        private var _playAnimationName:String; //현재 재생중인 애니메이션의 이름
        private var _playAnimationFlowIdx:int; //현재 재생중인 애니메이션의 Frame 인덱스
        private var _delayCnt:int;             //frame delay를 위한 카운트 변수
        private var _isPlaying:Boolean         //지금 재생중인지?
        
        public function AnimationPlayData(animationData:Dictionary, playAnimationName:String)
        {
            _animationData = animationData;
            _playAnimationName = playAnimationName;
            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
            _isPlaying = false;
        }
        
        /**
         * 이 PlayData를 소유한 STSprite의 플레이 중인 애니메이션을 반환하는 함수입니다.
         * @return 얻어낸 애니메이션
         */
        public function getPlayAnimation():Animation
        {
            return _animationData["animation"][_playAnimationName];
        }
        
        /**
         * 이 PlayData를 소유한 STSprite의 플레이 중인 애니메이션 프레임을 반환하는 함수입니다.
         * @return 현재 선택되어있는 애니메이션 프레임
         */
        public function getPlayAnimationFrame():AnimationFrame
        {
            return _animationData["frame"][getPlayAnimation().animationFlow[_playAnimationFlowIdx]];
        }
        
        /**
         * 이 프레임이 반복되어야 하는 횟수를 반환합니다.
         * @return 반복해야 될 횟수
         */
        public function getDelayNum():int
        {
            return getPlayAnimation().delayNum;
        }
        
        public function setPlayAnimation(name:String):void
        {
            _playAnimationName = name;
            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
        }
        
        public function clear():void
        {
           _animationData = null;
        }

        //get set함수들
        public function get animationData():Dictionary {return _animationData;}
        public function get playAnimationName():String {return _playAnimationName;}
        public function get playAnimationFlowIdx():int {return _playAnimationFlowIdx;}
        public function get delayCnt():int             {return _delayCnt;}
        public function get isPlaying():Boolean        {return _isPlaying;}
        
        public function set animationData(value:Dictionary):void {_animationData        = value;}
        public function set playAnimationName(value:String):void {_playAnimationName    = value;}       
        public function set playAnimationFlowIdx(value:int):void {_playAnimationFlowIdx = value;}
        public function set delayCnt(value:int):void             {_delayCnt             = value;}
        public function set isPlaying(value:Boolean):void        {_isPlaying            = value;}
    }
}
