package com.sundaytoz.st2D.animation
{
    /**
     * 하나의 애니메이션 정보가 저장되는 클래스입니다.
     * @author 신동환
     */
    public class Animation
    {
        private var _name:String;
        private var _animationNum:int;
        private var _animationFlow:Array;
        private var _framePauseNum:Array;
        private var _nextAnimationName:String
        
        /**
         * 애니메이션을 설정하는 함수 
         * @param name 애니메이션의 이름
         * @param animationNum 애니메이션의 장면 갯수
         * @param animationFlow 애니메이션 장면의 순서
         * @param framePauseNum 한 장면에서 몇프레임을 소비할 것인지(얼마나 멈춰있을 것인지)
         * @param nextAnimationName 다음 애니메이션의 이름
         */
        public function Animation(name:String, animationNum:int, animationFlow:Array, framePauseNum:Array, nextAnimationName:String)
        {
            _name = name;
            _animationNum = animationNum;
            _animationFlow = animationFlow;
            _framePauseNum = framePauseNum;
            _nextAnimationName = nextAnimationName;
        }

        public function get name():String
        {
            return _name;
        }

        public function set name(value:String):void
        {
            _name = value;
        }
        
        public function get animationNum():int
        {
            return _animationNum;
        }
        
        public function set animationNum(value:int):void
        {
            _animationNum = value;
        }
        
        public function get animationFlow():Array
        {
            return _animationFlow;
        }
        
        public function set animationFlow(value:Array):void
        {
            _animationFlow = value;
        }
        
        public function get framePauseNum():Array
        {
            return _framePauseNum;
        }
        
        public function set framePauseNum(value:Array):void
        {
            _framePauseNum = value;
        }

        public function get nextAnimationName():String
        {
            return _nextAnimationName;
        }
        
        public function set nextAnimationName(value:String):void
        {
            _nextAnimationName = value;
        }
    }
}