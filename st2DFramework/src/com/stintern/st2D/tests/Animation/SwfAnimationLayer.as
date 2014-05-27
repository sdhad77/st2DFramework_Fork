package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    import com.stintern.st2D.utils.AssetLoader;
    
    import flash.display.Bitmap;

    public class SwfAnimationLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _effect:SpriteAnimation = new SpriteAnimation;
        private var _effect2:Sprite = new Sprite;
        
        public function SwfAnimationLayer()
        {
            AssetLoader.instance.loadSWF("res/ice.swf", onLoad);
        }
        
        private function onLoad(result:Array):void
        {
            //애니메이션 데이터를 저장할 수 있게 path를 key로 하는 dictionary를 만들고 xml 데이터를 읽어옵니다.
            AnimationData.instance.createAnimationDictionaryWithSWF( (result[0] as Bitmap).name, result[1]);
            
            _batchSprite = new BatchSprite();
            _batchSprite.createSpriteWithBitmap(result[0]);
            addBatchSprite(_batchSprite);
          
            var arr:Array = new Array;
            
            for(var i:int=0; i< 60; i++)
            {
                arr.push(i.toString());
            }
            
            AnimationData.instance.setAnimation("res/ice.swf", new Animation("ice", arr, 1, "ice"));
            
            _effect.createAnimationSpriteWithBatchSprite(_batchSprite, "ice", 300, 300);
            _batchSprite.addSprite(_effect);
            _effect.playAnimation();
        }

        override public function update(dt:Number):void
        {
        }
    }
}