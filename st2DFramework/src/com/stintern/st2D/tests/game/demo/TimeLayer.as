package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.tests.Resources;
    
    public class TimeLayer extends Layer
    {
        private var _currentTime:uint;
        
        private var _batchSprite:BatchSprite;
        private var _spriteNumber:Array = new Array(); 
        
        private var _min:uint = 0;
        private var _sec:uint = 0;
        private var _mil:uint = 0;
       
        private var minSprite:Sprite = new Sprite();
        private var colonSprite:Sprite = new Sprite();
        private var secSprite:Sprite = new Sprite();
        private var secSprite2:Sprite = new Sprite();
        
        public function TimeLayer()
        {
            super();
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(Resources.PATH_SPRITE_NUMBER, Resources.PATH_XML_NUMBER, onCreated);
            
            addBatchSprite(_batchSprite);
        }
        
        private function onCreated():void
        {
            // 분 초기화
            minSprite.createSpriteWithBatchSprite(_batchSprite, "0", StageContext.instance.screenWidth * 0.5 - 32, StageContext.instance.screenHeight - 50);
            
            //' : ' 를 출력
            colonSprite.createSpriteWithBatchSprite(_batchSprite, "colon", StageContext.instance.screenWidth * 0.5, StageContext.instance.screenHeight - 50);
            
            // 초 초기화
            secSprite.createSpriteWithBatchSprite(_batchSprite, "0", StageContext.instance.screenWidth * 0.5 + 32, StageContext.instance.screenHeight - 50);
            secSprite2.createSpriteWithBatchSprite(_batchSprite, "0", StageContext.instance.screenWidth * 0.5 + 64, StageContext.instance.screenHeight - 50);
        }
        
        override public function update(dt:Number):void
        {
            _currentTime += dt;
            updateTime();
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
                        
            // 분 출력
            minSprite.getSpriteInBatchSprite(_batchSprite, _min.toString());
            _batchSprite.addSprite(minSprite);
            
            //' : ' 를 출력
            colonSprite.getSpriteInBatchSprite(_batchSprite, "colon");
            _batchSprite.addSprite( colonSprite );

            // 초 출력
            secSprite.getSpriteInBatchSprite(_batchSprite, (Math.floor(_sec / 10)).toString());
            _batchSprite.addSprite(secSprite);
            
            secSprite2.getSpriteInBatchSprite(_batchSprite, (Math.floor(_sec % 10)).toString());
            _batchSprite.addSprite(secSprite2);
        }
        
    }
}