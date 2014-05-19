package com.stintern.st2D.utils
{
    import flash.utils.getTimer;

    public class GameTimer
    {
        private var _startTime:Number = 0.0;            //게임 시작 시간    
        private var _lastFrameTime:Number = 0.0;    // 이전 프레임의 시간
        private var _curFrameTime:Number = 0.0;     // 현재 프레임의 시간
        
        private var _frameElapsed:Number = 0.0;     // 지난 프레임이후에 지난 시간
        private var _frameCount:uint = 0;                   // 총 프레임 개수
        
        private var _gameElapsedTime:uint = 0;      
        
        public function GameTimer()
        {
            
        }
        
        public function tick():void
        {
            _curFrameTime = getTimer();
            if( _frameCount == 0 )
            {
                _startTime = _curFrameTime;
                _frameElapsed = 0.0;
                _gameElapsedTime = 0;
            }
            else
            {
                _frameElapsed = _curFrameTime - _lastFrameTime;
                _gameElapsedTime += _frameElapsed;
            }
            
            _lastFrameTime = _curFrameTime;
            _frameCount++;
        }
        
        public function get deltaTime():Number
        {
            return _frameElapsed;
        }
    }
}