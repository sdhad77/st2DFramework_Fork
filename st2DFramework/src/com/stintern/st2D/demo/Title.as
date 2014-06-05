package com.stintern.st2D.demo
{
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
        private var _sprite5:SpriteAnimation;
        
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
            
            var scale:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_titleBatch.path]["frame"]["장면 1_0"].frameWidth;
            
            _sprite1 = new Sprite;
            _sprite1.createSpriteWithBatchSprite(_titleBatch, "장면 1_0", 512, 384);
            _sprite1.setScale(new Vector2D(scale,scale));
            _sprite1.setFrameStagePos("장면 1_0");
            _titleBatch.addSprite(_sprite1);
            
            _sprite2 = new Sprite;
            _sprite2.createSpriteWithBatchSprite(_titleBatch, "장면 1_1", 512, 384);
            _sprite2.setScale(new Vector2D(scale,scale));
            _sprite2.setFrameStagePos("장면 1_1");
            _titleBatch.addSprite(_sprite2);
            _sprite2.addEventListener("touch", touchEvent);
            
            
            _sprite3 = new Sprite;
            _sprite3.createSpriteWithBatchSprite(_titleBatch, "장면 1_2", 512, 384);
            _sprite3.setScale(new Vector2D(scale,scale));
            _sprite3.setFrameStagePos("장면 1_2");
            _titleBatch.addSprite(_sprite3);
            
            _sprite4 = new Sprite;
            _sprite4.createSpriteWithBatchSprite(_titleBatch, "장면 1_4", 512, 384);
            _sprite4.setScale(new Vector2D(scale,scale));
            _sprite4.setFrameStagePos("장면 1_4");
            _titleBatch.addSprite(_sprite4);
            
            _sprite5 = new SpriteAnimation;
            _sprite5.createAnimationSpriteWithBatchSprite(_titleBatch, "mole", "mole", 512,384);
            _sprite5.setScale(new Vector2D(scale,scale));
            _titleBatch.addSprite(_sprite5);
            _sprite5.playAnimation();
            
            function touchEvent():void
            {
                _sprite2.removeEventListener("touch", touchEvent);
                StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, buttonClick);
                
                var scene:Scene = new Scene();
                SceneManager.instance.pushScene(scene);
                
                var totalAnimationLayer:Game = new Game();
                scene.addLayer(totalAnimationLayer);
                
                var cloudLayer:CloudLayer = new CloudLayer();
                scene.addLayer(cloudLayer);
                
                var timeLayer:TimeLayer = new TimeLayer();
                scene.addLayer(timeLayer);
            }
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
            Event.instance.touchCheck(evt.stageX, evt.stageY);
        }
    }
}