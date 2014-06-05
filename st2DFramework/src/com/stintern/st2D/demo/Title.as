package com.stintern.st2D.demo
{
    import com.stintern.st2D.LayerSample.BackGroundLayer;
    import com.stintern.st2D.LayerSample.CloudLayer;
    import com.stintern.st2D.LayerSample.TimeLayer;
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Event;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;
    
    public class Title extends Layer
    {
        private var _titleBatch:BatchSprite;
        private var _sprite1:Sprite;
        private var _sprite2:Sprite;
        private var _sprite3:Sprite;
        private var _sprite4:Sprite;
        private var _sprite5:Sprite;
        private var _sprite6:SpriteAnimation;
        
        public function Title()
        {
            _titleBatch = new BatchSprite();
            _titleBatch.createBatchSpriteWithPath("res/system/title.png", "res/system/title.xml", loadCompleted, null, false);
            addBatchSprite(_titleBatch);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, buttonClick);
        }
        
        private function loadCompleted():void
        {
            AnimationData.instance.setAnimationAuto(_titleBatch.path, "res/system/title.xml", "mole");
            AnimationData.instance.setAnimationDelayNum(_titleBatch.path, "mole", 3);
            
            var scaleX:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_titleBatch.path]["frame"]["장면 1_0"].frameWidth;
            var scaleY:Number = StageContext.instance.screenHeight/AnimationData.instance.animationData[_titleBatch.path]["frame"]["장면 1_0"].frameHeight;
            var uiPosX:Number = StageContext.instance.screenWidth/2;
            var uiPosY:Number = StageContext.instance.screenHeight/2;
            
            _sprite1 = new Sprite;
            _sprite1.createSpriteWithBatchSprite(_titleBatch, "장면 1_0", uiPosX, uiPosY);
            _sprite1.setScale(new Vector2D(scaleY,scaleY));
            _sprite1.setFrameStagePos("장면 1_0");
            _titleBatch.addSprite(_sprite1);
            
            _sprite2 = new Sprite;
            _sprite2.createSpriteWithBatchSprite(_titleBatch, "장면 1_1", uiPosX, uiPosY);
            _sprite2.setScale(new Vector2D(scaleY,scaleY));
            _sprite2.setFrameStagePos("장면 1_1");
            _titleBatch.addSprite(_sprite2);
            
            _sprite3 = new Sprite;
            _sprite3.createSpriteWithBatchSprite(_titleBatch, "장면 1_2", uiPosX, uiPosY);
            _sprite3.setScale(new Vector2D(scaleY,scaleY));
            _sprite3.setFrameStagePos("장면 1_2");
            _sprite3.addEventListener("touch", startButtonTouch);
            _titleBatch.addSprite(_sprite3);
            
            _sprite4 = new Sprite;
            _sprite4.createSpriteWithBatchSprite(_titleBatch, "장면 1_3", uiPosX, uiPosY);
            _sprite4.setScale(new Vector2D(scaleY,scaleY));
            _sprite4.setFrameStagePos("장면 1_3");
            _titleBatch.addSprite(_sprite4);
            
            _sprite5 = new Sprite;
            _sprite5.createSpriteWithBatchSprite(_titleBatch, "장면 1_4", uiPosX, uiPosY);
            _sprite5.setScale(new Vector2D(scaleY,scaleY));
            _sprite5.setFrameStagePos("장면 1_4");
            _sprite5.addEventListener("touch", noticeCloseTouch);
            _titleBatch.addSprite(_sprite5);
            
            _sprite6 = new SpriteAnimation;
            _sprite6.createAnimationSpriteWithBatchSprite(_titleBatch, "mole", "mole", uiPosX, uiPosY);
            _sprite6.setScale(new Vector2D(scaleY,scaleY));
            _titleBatch.addSprite(_sprite6);
            _sprite6.playAnimation();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
            Event.instance.touchCheck(evt.stageX, evt.stageY);
        }
        
        private function startButtonTouch():void
        {
            clear();
            
            var scene:Scene = new Scene();
            SceneManager.instance.pushScene(scene);
            
            var backGroundLayer:BackGroundLayer = new BackGroundLayer();
            scene.addLayer(backGroundLayer);
            
            var game:Game = new Game();
            scene.addLayer(game);
            
            var cloudLayer:CloudLayer = new CloudLayer();
            scene.addLayer(cloudLayer);
            
            var timeLayer:TimeLayer = new TimeLayer();
            scene.addLayer(timeLayer);
        }
        
        private function noticeCloseTouch():void
        {
            _sprite5.removeEventListener("touch", noticeCloseTouch);
            
            _sprite2.isVisible = false;
            _sprite4.isVisible = false;
            _sprite5.isVisible = false;
        }
        
        private function clear():void
        {
            _sprite3.removeEventListener("touch", startButtonTouch);
            _sprite5.removeEventListener("touch", noticeCloseTouch);
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, buttonClick);
            
            _sprite1.dispose();
            _sprite2.dispose();
            _sprite3.dispose();
            _sprite4.dispose();
            _sprite5.dispose();
            _sprite6.dispose();
            _sprite1 = _sprite2 = _sprite3 = _sprite4 = _sprite5 = _sprite6 = null;
            
            _titleBatch.dispose();
            _titleBatch = null;
        }
    }
}