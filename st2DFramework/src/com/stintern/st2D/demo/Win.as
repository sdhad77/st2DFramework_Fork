package com.stintern.st2D.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;

    public class Win extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprite:Sprite;
        
        public function Win()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/system/gameUI.png", "res/system/gameUI.xml", loadCompleted, null, false);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {
            var scaleX:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_batchSprite.path]["frame"]["win_0"].frameWidth;
            var scaleY:Number = StageContext.instance.screenHeight/AnimationData.instance.animationData[_batchSprite.path]["frame"]["win_0"].frameHeight;
            var scale:Number = (scaleX>scaleY) ? scaleY : scaleX;
            
            _sprite = new Sprite;
            _sprite.createSpriteWithBatchSprite(_batchSprite, "win_0", -StageContext.instance.mainCamera.x, -StageContext.instance.mainCamera.y);
            _sprite.setScale(new Vector2D(scaleX,scaleY));
            _sprite.setFrameStagePos("win_0");
            _sprite.moveTo(-StageContext.instance.mainCamera.x, -StageContext.instance.mainCamera.y, 3000);
            _batchSprite.addSprite(_sprite);
        }
        
        override public function update(dt:Number):void
        {
        }
    }
}