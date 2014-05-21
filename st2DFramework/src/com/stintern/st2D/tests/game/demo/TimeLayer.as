package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    
    public class TimeLayer extends Layer
    {
        private var _currentTime:uint;
        
        private var _batchSprite:BatchSprite;
        private var _spriteNumber:Array = new Array(); 
        
        private var _min:uint = 0;
        private var _sec:uint = 0;
        private var _mil:uint = 0;
        
        public function TimeLayer()
        {
            super();
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/number.png", "res/number.xml", onCreated);
            addBatchSprite(_batchSprite);
        }
        
        override public function update(dt:Number):void
        {
            _currentTime += dt;
            updateTime();
        }
        
        private function onCreated():void
        {
//            // 숫자를 읽옴
//            for(var i:uint=0; i<10; ++i)
//            {
//                var sprite:Sprite = new Sprite();
//                sprite.createSpriteWithBatchSprite(_batchSprite, i.toString() );
//                
//                _spriteNumber.push(sprite);
//            }
//            //' : ' 를 읽음
//            var colonSprite:Sprite = new Sprite();
//            sprite.createSpriteWithBatchSprite(_batchSprite, "colon", StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight - 50);
//            _spriteNumber.push(sprite);
//            
//            _batchSprite.addSprite( sprite );
            
        }
        
        private function onSpriteCreated():void
        {
            
        }
        
        public function startTime():void
        {
            _currentTime = 0;
        }
        
        public function showTime():void
        {
            
        }
        
        public function updateTime():void
        {
            if( _batchSprite.imageLoaded == false )
                return;
            
            _sec = _currentTime/1000;
            if( _sec >= 60 )
            {
                _sec++;
                _min = 0;
            }
            
            _batchSprite.removeAllSprites();
            
            // 분 초기화
            var minSprite:Sprite = new Sprite();
            minSprite.createSpriteWithBatchSprite(_batchSprite, _min.toString(), StageContext.instance.screenWidth * 0.5 - 32, StageContext.instance.screenHeight - 50);
            _batchSprite.addSprite(minSprite);

            // 초 초기화
            var secSprite:Sprite = new Sprite();
            secSprite.createSpriteWithBatchSprite(_batchSprite, (Math.floor(_sec / 10)).toString(), StageContext.instance.screenWidth * 0.5 + 32, StageContext.instance.screenHeight - 50);
            _batchSprite.addSprite(secSprite);
            
            var secSprite2:Sprite = new Sprite();
            secSprite.createSpriteWithBatchSprite(_batchSprite, (Math.floor(_sec % 10)).toString(), StageContext.instance.screenWidth * 0.5 + 64, StageContext.instance.screenHeight - 50);
            _batchSprite.addSprite(secSprite2);
        }
        
        public function stopTime():void
        {
            
        }
           
    }
}