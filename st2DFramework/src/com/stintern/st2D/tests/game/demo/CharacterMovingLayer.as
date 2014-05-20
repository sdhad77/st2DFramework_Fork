package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.STSprite;
    
    import flash.events.MouseEvent;

    public class CharacterMovingLayer extends Layer
    {
        
        private var _backGround:STSprite;
        private var _bgPageNum:uint = 0;
        private var _layer:Layer;
        
        private var _batchSprite:BatchSprite;
        private var _sprites:Array = new Array();
        
        public function CharacterMovingLayer()
        {
            this.name = "CharacterMovingLayer";
            StageContext.instance.stage.addEventListener(MouseEvent.CLICK, onTouch);
                
                
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/dungGame.png", "res/atlas.xml", onCompleted);
            addBatchSprite(_batchSprite);
   //         AnimationData.instance.setAnimationData("res/demo/background.png", "res/atlas.xml", onCompleted );
        }
        
        private function onCompleted():void
        {
            AnimationData.instance.setAnimation("res/dungGame.png", new Animation("char",  new Array("char0", "char1"), 8, "char"));
        }

        
        private function onTouch(event:MouseEvent):void
        {
            
//            var _player:CharacterObject = new CharacterObject(this, "res/star.png", 100, 100, 20, true);
            
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