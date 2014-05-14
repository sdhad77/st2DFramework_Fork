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
        
        public function AnimationPlayData(animationData:Dictionary, playAnimationName:String)
        {
            _animationData = animationData;
            _playAnimationName = playAnimationName;
            _playAnimationFlowIdx = 0;
            _delayCnt = 0;
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

        //get set함수들
        public function get animationData():Dictionary {return _animationData;}
        public function get playAnimationName():String {return _playAnimationName;}
        public function get playAnimationFlowIdx():int {return _playAnimationFlowIdx;}
        public function get delayCnt():int             {return _delayCnt;}
        
        public function set animationData(value:Dictionary):void {_animationData        = value;}
        public function set playAnimationName(value:String):void {_playAnimationName    = value;}       
        public function set playAnimationFlowIdx(value:int):void {_playAnimationFlowIdx = value;}
        public function set delayCnt(value:int):void             {_delayCnt             = value;}
    } 
}
