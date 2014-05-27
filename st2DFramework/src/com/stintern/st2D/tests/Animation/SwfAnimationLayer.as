package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.display.sprite.Sprite;

    public class SwfAnimationLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _effect:SpriteAnimation = new SpriteAnimation;
        private var _effect2:Sprite = new Sprite;
        
        public function SwfAnimationLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithSWF("res/ice.swf", onCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function onCompleted():void
        {
            var arr:Array = new Array;
            
            for(var i:int=0; i< 60; i++)
            {
                arr.push(i.toString());
            }
            
            AnimationData.instance.setAnimation("res/ice.swf", new Animation("ice", arr, 2, "ice"));
        
            _effect.createAnimationSpriteWithBatchSprite(_batchSprite, "ice", 300, 300);
            _batchSprite.addSprite(_effect);
            _effect.playAnimation();
        }
        
        override public function update(dt:Number):void
        {
        }
    }
}