package com.stintern.st2D.display
{
    import com.stintern.st2D.display.sprite.Sprite;

    public class progressBar
    {
        private var _progressSprite:Sprite;
        
        private var _totalValue:Number;
        private var _currentValue:Number;
        private var _oldValue:Number;
        
        private var _oldWidth:Number;
        
        private var _oldScale:Number;
        private var _newScale:Number;
        
        public static var DECREASE_TO_LEFT:int = 0;
        public static var DECREASE_TO_RIGHT:int = 1;
        
        private var _decreseType:int = DECREASE_TO_LEFT;
        
        public function progressBar()
        {
        }
        
        /**
         * 프로그래스바를 초기화합니다. 
         * @param sprite 프로그래스바에 사용할 이미지
         * @param totalValue 프로그래스바 총 값(길이)
         * @param currentValue 프로그래스바의 초기 값
         * @param type progressBar.DECREASE_TO_LEFT : 프로그래스바가 왼쪽으로 줄어듬 <br/> 
         *                      progressBar.DECREASE_TO_RIGHT : 오른쪽으로 줄어듬
         */
        public function init(sprite:Sprite, totalValue:Number, currentValue:Number, type:int ):void
        {
            _progressSprite = sprite;
            
            _oldWidth = sprite.getContentWidth();
            _oldScale = sprite.scale.x;
            
            _totalValue = totalValue;
            _oldValue= _totalValue;
            
            _currentValue = currentValue;
            
            
            _decreseType = type;
        }
        
        /**
         * 특정 값으로 프로그래스바를 갱신합니다. 
         * @param value 갱신할 값(백분율 값이 아닌 실제 값(길이))
         */
        public function updateProgress(value:Number):void
        {
            _currentValue = value;
            var percent:Number = _currentValue/_oldValue;
            _oldValue = _currentValue;
            
            if( percent <= 0 )
                percent = 0.01;
            
            _newScale = _oldScale * percent;
            _progressSprite.scale.x = _newScale;
            
            var newWidth:Number = (_newScale / _oldScale) * _oldWidth;
            
            if( _decreseType == progressBar.DECREASE_TO_LEFT )
                _progressSprite.position.x -= (_oldWidth - newWidth) * 0.5;
            else if( _decreseType == progressBar.DECREASE_TO_RIGHT )
            _progressSprite.position.x += (_oldWidth - newWidth) * 0.5;
            
            _oldWidth = newWidth;
            _oldScale = _newScale;
        }
        
        /**
         * * 프로그래스바의 총 값(길이)를 반환합니다.
         */
        public function get totalValue():Number
        {
            return _totalValue;
        }
        
        /**
         * 프로그래스바의 총 값(길이)를 입력합니다.
         */
        public function set totalValue(total:Number):void
        {
            _totalValue = total;
        }
        
        /**
         * 현재 프로그래스바의 값을 입력합니다. 
         */
        public function get currentValue():Number
        {
            return _currentValue;
        }
        
        /**
         * 현재 프로그래스바의 값을 반환합니다. 
         */
        public function set currentValue(currentValue):void
        {
            _currentValue = currentValue;
        }
        
        /**
         * 현재 프로그레스바의 백분율 퍼센트를 반환합니다. 
         */
        public function get percent():Number
        {
            return _currentValue/_totalValue; 
        }
    }
}