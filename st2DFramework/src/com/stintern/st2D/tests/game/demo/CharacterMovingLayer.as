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
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCompleted);
            addBatchSprite(_batchSprite);
           
        }
        
        
        private function onCompleted():void
        {
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character_run",  new Array("character_run0", "character_run1"), 8, "character_run"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character_attack",  new Array("character_attack0", "character_attack1"), 8, "character_attack"));
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