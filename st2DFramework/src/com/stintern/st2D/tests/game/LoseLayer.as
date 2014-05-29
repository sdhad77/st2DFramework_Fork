package com.stintern.st2D.tests.game
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.tests.game.demo.BackGroundLayer;
    import com.stintern.st2D.tests.game.demo.CharacterMovingLayer;
    import com.stintern.st2D.tests.game.demo.CloudLayer;
    import com.stintern.st2D.tests.game.demo.ControlLayer;
    import com.stintern.st2D.tests.game.demo.TimeLayer;
    
    import flash.events.MouseEvent;
    
    public class LoseLayer extends Layer
    {
        private var sprite1:Sprite = new Sprite();
        
        public function LoseLayer()
        {
            sprite1.createSpriteWithPath("res/gameover.jpg", onCreated, null, StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
            
        }
        
        private function onCreated():void
        {
            this.addSprite(sprite1);
        }
        
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