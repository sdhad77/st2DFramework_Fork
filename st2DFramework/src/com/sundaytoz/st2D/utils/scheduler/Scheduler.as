package com.sundaytoz.st2D.utils.scheduler
{
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * Tesk를 저장하여 설정한 간격시간마다 반복 싱행 시켜 줍니다.
     * addFunc를 통해 작업을 추가, startScheduler을 통해 실행.
     * @author 구현모
     * 
     */
    public class Scheduler extends Sprite
    {
        
        private var _schedule:Vector.<TeskData>;
        private var _scheduleTimer:Vector.<Timer>;
        
        public function Scheduler()
        {
            _schedule = new Vector.<TeskData>();
            _scheduleTimer = new Vector.<Timer>();
        }
        
        /**
         * 
         * @param milliSecond 함수가 실행될 간격 시간
         * @param func 간격별로 실행될 함수
         * @param repeat 반복 횟수 0 = 무한
         * 
         */
        public function addFunc(milliSecond:Number, func:Function, repeat:int=0):void
        {
            var teskData:TeskData = new TeskData(milliSecond, func);
            var timer:Timer = new Timer(milliSecond, repeat);

            _schedule.push(teskData);
            _scheduleTimer.push(timer);
        }
        
        /**
         * 추가된 작업들을 모두 실행합니다.
         */
        public function startScheduler():void
        {
            for(var i:uint=0; i<_schedule.length; i++)
            {
                _scheduleTimer[i].addEventListener(TimerEvent.TIMER, _schedule[i].func);
                _scheduleTimer[i].start();
            }
        }
        
        /**
         * 실행중인 작업들을 모두 중지합니다. 
         */
        public function stopScheduler():void
        {
            for(var i:uint=0; i<_schedule.length; i++)
            {
                _scheduleTimer[i].stop();
                _scheduleTimer[i].removeEventListener(TimerEvent.TIMER, _schedule[i].func);
            }
        }

    }
    
}