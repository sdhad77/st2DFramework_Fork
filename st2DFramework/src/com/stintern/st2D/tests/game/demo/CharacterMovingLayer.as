package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;

    public class CharacterMovingLayer extends Layer
    {
        
        private var _backGround:Sprite;
        private var _bgPageNum:uint = 0;
        private var _layer:Layer;
        
        private var _batchSprite:BatchSprite;
        private var _sprites:Array = new Array();
        
        public function CharacterMovingLayer()
        {
            this.name = "CharacterMovingLayer";
                
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/dungGame.png", "res/atlas.xml", onCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function onCompleted():void
        {
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("char",  new Array("char0", "char1"), 8, "char"));
        }
        
        override public function update(dt:Number):void
        {
        }

        public function get batchSprite():BatchSprite
        {
            return _batchSprite;
        }

        public function set batchSprite(value:BatchSprite):void
        {
            _batchSprite = value;
        }

        public function get sprites():Array
        {
            return _sprites;
        }

        public function set sprites(value:Array):void
        {
            _sprites = value;
        }
        
        
        
    }
}