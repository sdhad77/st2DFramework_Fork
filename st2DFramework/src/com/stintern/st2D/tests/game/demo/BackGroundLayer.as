package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    
    public class BackGroundLayer extends Layer
    {
        
        private var _batchSprite:BatchSprite;
        private var _sprites:Array = new Array();
        
        private var _bgPageCounter:uint = 0;
        private var _bgPageNum:uint = 4;
        
        public function BackGroundLayer()
        {
            this.name = "BackGroundLayer";
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCreated);
            addBatchSprite(_batchSprite);
        }

        private function onCreated():void
        {
            for(var i:uint = 0; i<_bgPageNum; i++)
            {
                var sprite:Sprite = new Sprite();
                _sprites.push(sprite);
                var x:Number = (StageContext.instance.screenWidth/2) + (StageContext.instance.screenWidth * _bgPageCounter);
                var y:Number = StageContext.instance.screenHeight/2;
                sprite.createSpriteWithBatchSprite(_batchSprite, "background0", x, y );
                sprite.setScaleWithWidthHeight(StageContext.instance.screenWidth, StageContext.instance.screenHeight);
                _batchSprite.addSprite(sprite);
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

        public function get bgPageNum():uint
        {
            return _bgPageNum;
        }

    }
}


