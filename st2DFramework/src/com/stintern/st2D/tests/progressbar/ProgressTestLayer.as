package com.stintern.st2D.tests.progressbar
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.ProgressBar;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    
    import flash.events.MouseEvent;
    
    public class ProgressTestLayer extends Layer
    {
        private var spriteBkg:Sprite;
        private var spriteFront:Sprite;
        
        private var _batchSprite:BatchSprite = new BatchSprite();
        private var _hpProgress:ProgressBar = new ProgressBar(); 
        
        public function ProgressTestLayer()
        {            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
            
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onBatchSpriteCreated);
            addBatchSprite(_batchSprite);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function onBatchSpriteCreated():void
        {
            //프로그래스바 뒷 배경으로 사용할 이미지 설정
            spriteBkg = new Sprite();
            spriteBkg.createSpriteWithBatchSprite(_batchSprite, "hp_bkg", 500, 500);
            spriteBkg.scale.x = 3.0
            _batchSprite.addSprite(spriteBkg);
            
            // 프로그래스바로 사용할 이미지 설정 
            spriteFront = new Sprite();
            spriteFront.createSpriteWithBatchSprite(_batchSprite, "hp_front", 500, 500);
            spriteFront.scale.x = 3.0;
            spriteFront.scale.y = 0.8;
            _batchSprite.addSprite(spriteFront);
            
            // 뒷 배경의 자식으로 프로그래스바 이미지를 설정
            spriteBkg.addChild(spriteFront);
            
            // 프로그래스바 초기화
            _hpProgress.init(spriteFront, 100, 100, ProgressBar.FROM_LEFT);
        }
        
        // 프로그래스바 테스트
        private var hp:Number = 100;
        private function onTouch(event:MouseEvent):void
        {
            _hpProgress.updateProgress(hp);
            hp -= 5;
        }
    }
}