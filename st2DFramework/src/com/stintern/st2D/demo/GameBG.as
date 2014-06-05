package com.stintern.st2D.demo
{
    import com.stintern.st2D.LayerSample.utils.Resources;
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    
    public class GameBG extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprite:Sprite;
        
        public function GameBG()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(Resources.PATH_SPRITE_BACKGROUND, Resources.PATH_XML_BACKGROUND, onCreated, null, false);
            addBatchSprite(_batchSprite);
        }

        private function onCreated():void
        {
            var scaleX:Number = StageContext.instance.screenWidth/AnimationData.instance.animationData[_batchSprite.path]["frame"]["bg2"].frameWidth;
            var scaleY:Number = StageContext.instance.screenHeight/AnimationData.instance.animationData[_batchSprite.path]["frame"]["bg2"].frameHeight;
            var scale:Number = (scaleX>scaleY) ? scaleY : scaleX;
            
            _sprite = new Sprite;
            _sprite.createSpriteWithBatchSprite(_batchSprite, "bg2", StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
            _sprite.setScale(new Vector2D(scale,scale));
            _sprite.position.y = -_sprite.height/2 * _sprite.scale.y + StageContext.instance.screenHeight;
            _batchSprite.addSprite(_sprite);
        }
        
        override public function update(dt:Number):void
        {
        }
    }
}


