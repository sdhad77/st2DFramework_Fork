package com.stintern.st2D.LayerSample
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.LayerSample.utils.Resources;
    
    public class TimeLayer extends Layer
    {
        private var _currentTime:uint;
        
        private var _batchSprite:BatchSprite;
        
        private var _tenMin:uint = 0;
        private var _min:uint = 0;
        private var _sec:uint = 0;
        private var _mil:uint = 0;
       
        private var tenMinSprite:Sprite = new Sprite();
        private var minSprite:Sprite = new Sprite();
        private var colonSprite:Sprite = new Sprite();
        private var secSprite:Sprite = new Sprite();
        private var secSprite2:Sprite = new Sprite();
        
        public function TimeLayer()
        {
            super();
            this.name = "TimeLayer";
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(Resources.PATH_SPRITE_NUMBER, Resources.PATH_XML_NUMBER, onCreated, null, false);
            
            addBatchSprite(_batchSprite);
        }
        
        private function onCreated():void
        {
            // 10분 초기화
            tenMinSprite.createSpriteWithBatchSprite(_batchSprite, "0", StageContext.instance.screenWidth * 0.5 - 64, StageContext.instance.screenHeight - 50);
            tenMinSprite.isVisible = false;
            
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
            updatePos();
        }

        public function updateTime():void
        {
            if( _batchSprite.imageLoaded == false )
                return;
            
            _sec = _currentTime/1000;
            if( _sec >= 60 )
            {
                _min++;
                if(_min == 10)
                {
                    if(_tenMin == 0) { tenMinSprite.isVisible = true; }
                    _tenMin++;
                    if(_tenMin == 10)
                    {
                        _tenMin = 0;
                        _currentTime = 0;
                        tenMinSprite.isVisible = false;
                    }
                    _min = 0;
                }
                _sec = 0;
                _currentTime = 0;
            }
            
            _batchSprite.removeAllSprites();
                        
            // 분 출력
            tenMinSprite.getSpriteInBatchSprite(_batchSprite, _tenMin.toString());
            _batchSprite.addSprite(tenMinSprite);

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
        
        private function updatePos():void
        {
            //카메라 위치가 바뀐 경우에만 업데이트 하도록 조건 설정해야함
            if(1)
            {
                tenMinSprite.position.x = -StageContext.instance.mainCamera.x - 64;
                minSprite.position.x    = -StageContext.instance.mainCamera.x - 32;
                colonSprite.position.x  = -StageContext.instance.mainCamera.x;
                secSprite.position.x    = -StageContext.instance.mainCamera.x + 32;
                secSprite2.position.x   = -StageContext.instance.mainCamera.x + 64;
            }
        }

        public function get batchSprite():BatchSprite
        {
            return _batchSprite;
        }

        
    }
}