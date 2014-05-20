package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.STSprite;
    
    public class BackGroundLayer extends Layer
    {
        
        private var _batchSprite:BatchSprite;
        private var _sprites:Array = new Array();
        
        private var _bgPageCounter:uint = 0;
        private var _bgPageNum:uint = 2;
        
        public function BackGroundLayer()
        {
            AnimationData.instance.setAnimationData("res/demo/background.png", "res/atlas.xml", onCompleted );
        }
        
        private function onCompleted():void
        {
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/background.png", onCreated);
            addBatchSprite(_batchSprite);
        }
        
        private function onCreated():void
        {
            var tempFrame:AnimationFrame = AnimationData.instance.animationData["res/demo/background.png"]["frame"]["background0"]
            
            for(var i:uint = 0; i<_bgPageNum; i++)
            {
                var sprite:STSprite = new STSprite();
                _sprites.push(sprite);
                var x:Number = tempFrame.width/2 + (tempFrame.width * _bgPageCounter);
                var y:Number = tempFrame.height/2;
                sprite.createSpriteWithBatchSprite(_batchSprite, "background0", onSpriteCreated, x, y );
                _bgPageCounter++;
            }
        }
        
        private function onSpriteCreated():void
        {
            _batchSprite.addSprite(_sprites[_sprites.length-1]);
        }
        
        override public function update(dt:Number):void
        {
        }
    }
}


