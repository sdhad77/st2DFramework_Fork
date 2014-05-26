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
                _sprites.push(new Sprite());
                var x:Number = (StageContext.instance.screenWidth/2) + (StageContext.instance.screenWidth * i);
                var y:Number = StageContext.instance.screenHeight/2;
                _sprites[i].createSpriteWithBatchSprite(_batchSprite, "background0", x, y );
                _sprites[i].setScaleWithWidthHeight(StageContext.instance.screenWidth, StageContext.instance.screenHeight);
                if(i%2 == 1) _sprites[i].reverseLeftRight();
                _batchSprite.addSprite(_sprites[i]);
            }
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


