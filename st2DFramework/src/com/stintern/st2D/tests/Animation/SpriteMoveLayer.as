package com.stintern.st2D.tests.Animation
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;
    
    import flash.events.MouseEvent;
    
    public class SpriteMoveLayer extends Layer
    {
        private var _sprite:Vector.<SpriteAnimation> = new Vector.<SpriteAnimation>;
        private var _batchSprite:BatchSprite;
        
        public function SpriteMoveLayer()
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/skel.png", "res/skel.xml", loadCompleted);
            addBatchSprite(_batchSprite);
            
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function loadCompleted():void
        { 
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "right", 8);
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "up",    8);
            AnimationData.instance.setAnimationDelayNum(_batchSprite.path, "down",  8);
            
            for(var i:int=0; i < 3; i++)
            {
                _sprite.push(new SpriteAnimation());
                _sprite[i].createAnimationSpriteWithBatchSprite(_batchSprite, "right", "right", i*32 + 100, 32 + 100);
                _batchSprite.addSprite(_sprite[i]);
                _sprite[i].playAnimation();
            }
        }
        
        private function onTouch(event:MouseEvent):void
        {
            for(var i:int=0; i < _sprite.length; i++)
            {
                _sprite[i].moveBy(Math.random()*100, Math.random()*100, Math.random()*1000);
            }
        }
    }
}