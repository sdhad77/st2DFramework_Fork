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
        private var _fpsTextField:TextField;
        
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
                var mem:Number = Number((System.totalMemory * 0.000000954).toFixed(1));
                var fps:Number = _fpsTicks / dt * 1000;
                
                show(fps, mem);
                
                _fpsTicks = 0;
                _fpsLast = now;
            }
            
            _drawCallCount = 0;
        }
        
        public function increaseDrawCallCount():void
        {
            _drawCallCount++;
        }
        
        public function resetDrawCallCount():void
        {
            _drawCallCount = 0;
        }
        
        public function get drawCallCount():uint
        {
            return _drawCallCount;
        }
        
        /**
         * FPS 를 출력합니다. 
         * @param fps 출력할 FPS 
         * @param mem   출력할 메모리 사용량
         */
        private function show(fps:Number, mem:Number):void
        {
            _fpsTextField.text = fps.toFixed(1) + " fps\n" + "Memory used: " + mem + " MB\n" + "Draw Call Count: " + _drawCallCount;
            
            trace(_fpsTextField.text);
        }

        
        /**
         * FPS 텍스트필드를 초기화합니다. 
         */
        private function initFPSTextField():void
        {
            var myFormat:TextFormat = new TextFormat();  
            myFormat.color = 0xFF0000;
            myFormat.size = 16;
            
            _fpsTextField = new TextField();
            _fpsTextField.x = 10;
            _fpsTextField.y = 10;
            _fpsTextField.selectable = false;
            _fpsTextField.autoSize = TextFieldAutoSize.LEFT;
            _fpsTextField.defaultTextFormat = myFormat;
            
            addChild(_fpsTextField);
        }

    }
}