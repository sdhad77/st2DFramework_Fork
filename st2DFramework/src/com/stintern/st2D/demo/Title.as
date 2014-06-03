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
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;
    
    public class Title extends Layer
    {
        private var _titleBatch:BatchSprite;
        
        public function Title()
        {
            _titleBatch = new BatchSprite();
            _titleBatch.createBatchSpriteWithPath("res/system/title.png", "res/system/title.xml", loadCompleted);
            addBatchSprite(_titleBatch);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, buttonClick);
        }
        
        private function loadCompleted():void
        {
            AnimationData.instance.setAnimationDelayNum(_titleBatch.path, "mole", 3);
            
            var scale:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_titleBatch.path]["frame"]["장면 1_0"].frameWidth;
            
            var sprite1:Sprite = new Sprite;
            sprite1.createSpriteWithBatchSprite(_titleBatch, "장면 1_0", 512, 384);
            sprite1.setScale(new Vector2D(scale,scale));
            sprite1.setFrameStagePos("장면 1_0");
            _titleBatch.addSprite(sprite1);
            
            var sprite2:Sprite = new Sprite;
            sprite2.createSpriteWithBatchSprite(_titleBatch, "장면 1_1", 512, 384);
            sprite2.setScale(new Vector2D(scale,scale));
            sprite2.setFrameStagePos("장면 1_1");
            _titleBatch.addSprite(sprite2);
            
            var sprite3:Sprite = new Sprite;
            sprite3.createSpriteWithBatchSprite(_titleBatch, "장면 1_2", 512, 384);
            sprite3.setScale(new Vector2D(scale,scale));
            sprite3.setFrameStagePos("장면 1_2");
            _titleBatch.addSprite(sprite3);
            
            var sprite4:Sprite = new Sprite;
            sprite4.createSpriteWithBatchSprite(_titleBatch, "장면 1_4", 512, 384);
            sprite4.setScale(new Vector2D(scale,scale));
            sprite4.setFrameStagePos("장면 1_4");
            _titleBatch.addSprite(sprite4);
            
            var sprite5:SpriteAnimation = new SpriteAnimation;
            sprite5.createAnimationSpriteWithBatchSprite(_titleBatch, "mole", "mole",512,384);
            sprite5.setScale(new Vector2D(scale,scale));
            _titleBatch.addSprite(sprite5);
            sprite5.playAnimation();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
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
}