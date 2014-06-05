package com.stintern.st2D.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Event;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    import flash.events.MouseEvent;

    public class GameUI extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprite1:Sprite;
        private var _sprite2:Sprite;
        private var _sprite3:Sprite;
        private var _sprite4:Sprite;
        private var _sprite5:Sprite;
        
        public function GameUI()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/system/gameUI.png", "res/system/gameUI.xml", loadCompleted, null, false);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {
            var scaleX:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_batchSprite.path]["frame"]["장면 1_0"].frameWidth;
            var scaleY:Number = StageContext.instance.screenHeight/AnimationData.instance.animationData[_batchSprite.path]["frame"]["장면 1_0"].frameHeight;
            var uiPosX:Number = StageContext.instance.screenWidth/2;
            var uiPosY:Number = StageContext.instance.screenHeight/2;
            
            _sprite1 = new Sprite;
            _sprite1.createSpriteWithBatchSprite(_batchSprite, "장면 1_0", uiPosX, uiPosY);
            _sprite1.setScale(new Vector2D(scaleY,scaleY));
            _sprite1.setFrameStagePos("장면 1_0");
            _batchSprite.addSprite(_sprite1);
            
            _sprite2 = new Sprite;
            _sprite2.createSpriteWithBatchSprite(_batchSprite, "장면 1_1", uiPosX, uiPosY);
            _sprite2.setScale(new Vector2D(scaleY,scaleY));
            _sprite2.setFrameStagePos("장면 1_1");
            _batchSprite.addSprite(_sprite2);
            
            _sprite3 = new Sprite;
            _sprite3.createSpriteWithBatchSprite(_batchSprite, "장면 1_2", uiPosX, uiPosY);
            _sprite3.setScale(new Vector2D(scaleY,scaleY));
            _sprite3.setFrameStagePos("장면 1_2");
            _batchSprite.addSprite(_sprite3);
            
            _sprite4 = new Sprite;
            _sprite4.createSpriteWithBatchSprite(_batchSprite, "장면 1_3", uiPosX, uiPosY);
            _sprite4.setScale(new Vector2D(scaleY,scaleY));
            _sprite4.setFrameStagePos("장면 1_3");
            _sprite4.addEventListener("touch", unitCreateButton1);
            _batchSprite.addSprite(_sprite4);
            
            _sprite5 = new Sprite;
            _sprite5.createSpriteWithBatchSprite(_batchSprite, "장면 1_4", uiPosX, uiPosY);
            _sprite5.setScale(new Vector2D(scaleY,scaleY));
            _sprite5.setFrameStagePos("장면 1_4");
            _sprite5.addEventListener("touch", unitCreateButton2);
            _batchSprite.addSprite(_sprite5);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, buttonClick);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function buttonClick(evt:MouseEvent):void
        {
            Event.instance.touchCheck(evt.stageX, evt.stageY);
        }
        
        private function unitCreateButton1():void
        {
            trace("1");
        }
        
        private function unitCreateButton2():void
        {
            trace("2");
        }
    }
}