package com.sundaytoz.st2D.utils
{
    import flash.display.Sprite;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.getTimer;

    /**
     * FPS 를 계산하고 출력합니다. 
     */
    public class GameStatus extends Sprite
    {
        // 싱글톤 관련 변수들
        private static var _instance:GameStatus;
        private static var _creatingSingleton:Boolean = false;
        
        private var _fpsTicks:uint = 0;
        private var _fpsLast:uint = 0;
        
        private var _isFPSVisible:Boolean = true;       // FPS 를 출력하지 않으려면 false 로 두면 됩니다.
        private var _statusTextField:TextField;
        
        private var _fps:Number = 0.0;
        private var _memory:Number = 0.0;
        private var _drawCallCount:uint = 0;
        
        public function GameStatus()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():GameStatus
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new GameStatus();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        public function initFPS():Sprite
        {
            initFPSTextField();
            
            return this;
        }
        
        /**
         * FPS, 메모리 사용량, DrawCall 횟수를 갱신하고 출력합니다. 
         */
        public function update():void
        {
            _fpsTicks++;
            
            var now:uint = getTimer();
            var dt:uint = now - _fpsLast;
            
            if( dt >= 1000 )
            {
                _memory = Number((System.totalMemory * 0.000000954).toFixed(1));
                _fps = _fpsTicks / dt * 1000;
                
                //show();
                
                _fpsTicks = 0;
                _fpsLast = now;
            }
            
            displayStatus();
            _drawCallCount = 0;
        }
        
        /**
         * Draw call 횟수를 증가시킵니다. 
         */
        public function increaseDrawCallCount():void
        {
            _drawCallCount++;
        }
        
        /**
         * FPS, Memory 사용량, Drawcall 횟수를 출력합니다.
         */
        private function displayStatus():void
        {
            _statusTextField.text = _fps.toFixed(1) + " fps\n" + "Memory used: " + _memory + " MB\n" + "Draw Call Count: " + _drawCallCount; 
            
            trace(_statusTextField.text);
        }

        
        /**
         * FPS 텍스트필드를 초기화합니다. 
         */
        private function initFPSTextField():void
        {
            var myFormat:TextFormat = new TextFormat();  
            myFormat.color = 0xFF0000;
            myFormat.size = 16;
            
            _statusTextField = new TextField();
            _statusTextField.x = 10;
            _statusTextField.y = 10;
            _statusTextField.selectable = false;
            _statusTextField.autoSize = TextFieldAutoSize.LEFT;
            _statusTextField.defaultTextFormat = myFormat;
            
            addChild(_statusTextField);
        }
        
        /**
         * 현재 FPS 를 반환합니다. 
         */
        public function get fps():Number
        {
            return _fps;
        }

    }
}