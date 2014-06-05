package com.stintern.st2D.LayerSample
{
    import com.stintern.st2D.LayerSample.utils.Resources;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    
    public class BackGroundLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _sprite:Sprite;
        
        public function BackGroundLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(Resources.PATH_SPRITE_BACKGROUND, Resources.PATH_XML_BACKGROUND, onCreated, null, false);
            addBatchSprite(_batchSprite);
        }

        private function onCreated():void
        {
            _sprite = new Sprite;
            _sprite.createSpriteWithBatchSprite(_batchSprite, "bg1", StageContext.instance.screenWidth/2, StageContext.instance.screenHeight/2);
            _sprite.setScaleWithWidthHeight(StageContext.instance.screenWidth, StageContext.instance.screenHeight);
            _batchSprite.addSprite(_sprite);
        }
        
        override public function update(dt:Number):void
        {
        }
    }
}


