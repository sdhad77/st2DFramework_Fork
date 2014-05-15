package com.sundaytoz.st2D.animation.datatype
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
        private var _isMoving:Boolean;         //지금 움직이는지?
        private var _moveX:int;                //지금 움직이는중이면 얼마만큼씩 움직여야 하는지
        private var _moveY:int;                //지금 움직이는중이면 얼마만큼씩 움직여야 하는지
        
        public function AnimationPlayData(animationData:Dictionary, playAnimationName:String)
        {
            _animationData = animationData;
            _playAnimationName = playAnimationName;
            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
            _isMoving = false;
            _moveX = 0;
            _moveY = 0;
        }
        
        /**
         * AnimationManager 작성시 편의를 위해 만든 함수입니다.</br>
         * 매개변수로 받은 애니메이션을 반환합니다. 
         * @param name 얻고 싶은 애니메이션의 이름
         * @return 얻어낸 애니메이션
         */
        public function getPlayAnimation(name:String):Animation
        {
            return _animationData["animation"][name];
        }
        
        public function setPlayAnimation(name:String):void
        {
            _playAnimationName = name;
            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
            _isMoving = false;
            _moveX = 0;
            _moveY = 0;
        }

        //get set함수들
        public function get animationData():Dictionary {return _animationData;}
        public function get playAnimationName():String {return _playAnimationName;}
        public function get playAnimationFlowIdx():int {return _playAnimationFlowIdx;}
        public function get delayCnt():int             {return _delayCnt;}
        public function get isMoving():Boolean         {return _isMoving;}
        public function get moveX():int                {return _moveX;}
        public function get moveY():int                {return _moveY;}
        
        public function set animationData(value:Dictionary):void {_animationData        = value;}
        public function set playAnimationName(value:String):void {_playAnimationName    = value;}       
        public function set playAnimationFlowIdx(value:int):void {_playAnimationFlowIdx = value;}
        public function set delayCnt(value:int):void             {_delayCnt             = value;}
        public function set isMoving(value:Boolean):void         {_isMoving             = value;}
        public function set moveX(value:int):void                {_moveX                = value;}
        public function set moveY(value:int):void                {_moveY                = value;}
    }
}
