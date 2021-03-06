package com.stintern.st2D.animation.datatype
{
    /**
     * 하나의 애니메이션 정보가 저장되는 클래스입니다.
     * @author 신동환
     */
    public class Animation
    {
        private var _name:String;
        private var _animationFlow:Array;
        private var _delayNum:Number;

        /**
         * @param name 애니메이션의 이름
         * @param animationFlow 애니메이션 장면의 순서
         * @param framePauseNum 한 장면에서 몇프레임을 소비할 것인지(얼마나 멈춰있을 것인지)
         * @param nextAnimationName 다음 애니메이션의 이름
         */
        public function Animation(name:String, animationFlow:Array, framePauseNum:Number)
        {
            _name = name;
            _animationFlow = animationFlow;
            _delayNum = framePauseNum;
        }

        public function get name():String              {return _name;          }
        public function get animationFlow():Array      {return _animationFlow; }
        public function get delayNum():Number          {return _delayNum;      }
        
        public function set name(value:String):void              {_name          = value;}
        public function set animationFlow(value:Array):void      {_animationFlow = value;}
        public function set delayNum(value:Number):void          {_delayNum      = value;}
    }
}