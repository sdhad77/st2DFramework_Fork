package com.stintern.st2D.utils.scheduler
{
    /**
     * Scheduler 작업 간격 시간과 함수를 저장
     * @author 구현모
     * 
     */
    public class TeskData
    {
        private var _milliSecond:Number;
        private var _func:Function;
        
        public function TeskData(milliSecond, func)
        {
            _milliSecond = milliSecond;
            _func = func;
        }
        
        public function get milliSecond():Number
        {
            return _milliSecond;
        }

        public function set milliSecond(value:Number):void
        {
            _milliSecond = value;
        }


        public function get func():Function
        {
            return _func;
        }

        public function set func(value:Function):void
        {
            _func = value;
        }
    }
}