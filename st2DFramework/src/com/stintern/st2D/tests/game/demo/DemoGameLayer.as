package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    
    import flash.events.MouseEvent;
    
    public class DemoGameLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        public function DemoGameLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCompleted);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        private function onCompleted():void
        {
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character1_run_right",    new Array("character1_run_right0",    "character1_run_right1"),    8, "character1_run_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character1_attack",       new Array("character1_attack0",       "character1_attack1"),       8 ,"character1_attack"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character2_run_right",    new Array("character2_run_right0",    "character2_run_right1"),    8, "character2_run_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character2_attack_right", new Array("character2_attack_right0", "character2_attack_right1"), 8 ,"character2_attack_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character3_run_left",     new Array("character3_run_left0",     "character3_run_left1"),     8, "character3_run_left"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character3_attack_left",  new Array("character3_attack_left0",  "character3_attack_left1"),  8 ,"character3_attack_left"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("castle",                  new Array("castle0"),                                               8 ,"castle"));            
        }
        
        override public function update(dt:Number):void
        {
        }
        
        /**
         * Demo게임의 레이어 들을 add하여 보여줍니다.
         * @param event
         * 
         */
        private function onTouch(event:MouseEvent):void
        {
            var scene:Scene = new Scene();
            SceneManager.instance.pushScene(scene);
            
            var backGroundLayer:BackGroundLayer = new BackGroundLayer();
            scene.addLayer(backGroundLayer);
            
            var characterMovingLayer:CharacterMovingLayer = new CharacterMovingLayer();
            scene.addLayer(characterMovingLayer);
            
            var cloudLayer:CloudLayer = new CloudLayer();
            scene.addLayer(cloudLayer);
            
            var timeLayer:TimeLayer = new TimeLayer();
            scene.addLayer(timeLayer);
            
            var controlLayer:ControlLayer = new ControlLayer();
            scene.addLayer(controlLayer);
            
            StageContext.instance.stage.removeEventListener(MouseEvent.CLICK, onTouch);
        }
    }
}