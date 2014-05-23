package com.stintern.st2D.display
{
    import com.stintern.st2D.display.sprite.Sprite;

    public class ProgressBar
    {
        private var _progressSprite:Sprite;
        
        private var _totalValue:Number;
        
        private var _originX:Number;
        private var _originWdith:Number;
        private var _originScaleX:Number;
        
        public static var FROM_LEFT:int = 0;
        public static var FROM_RIGHT:int = 1;
        
        private var _progressType:int = FROM_LEFT;
        
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
            
            _totalValue = totalValue;
            
            _progressType = type;
            
            _originX = sprite.position.x;
            _originWdith = sprite.getContentWidth();
            _originScaleX = sprite.scale.x;
            
            updateProgress(currentValue);
        }
        
        /**
         * 특정 값으로 프로그래스바를 갱신합니다. 
         * @param value 갱신할 값(백분율 값이 아닌 실제 값(길이))
         */
        public function updateProgress(value:Number):void
        {
            if(_progressSprite.scale == null)
                return;
            
            if( value > _totalValue )
                value = totalValue;
            
            var scale:Number = value / _totalValue;
            if( scale <= 0 )
                scale = 0.001;
            
            _progressSprite.scale.x = _originScaleX * scale;
            
            if( _progressType == ProgressBar.FROM_LEFT )
                _progressSprite.position.x = _originX - ( _originWdith - (_originWdith*scale) ) / 2;
            else
                _progressSprite.position.x = _originX + ( _originWdith - (_originWdith*scale) ) / 2;
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
    }
}