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
        
        private var _playerCharacterArray:Array;
        private var _enemyCharacterArray:Array;
        
        public function CharacterMovingLayer()
        {
            this.name = "CharacterMovingLayer";
              
            _batchSprite = new BatchSprite();
            _playerCharacterArray = new Array();
            _enemyCharacterArray = new Array();
            
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCompleted);
            addBatchSprite(_batchSprite);
           
        }
        
        
        private function onCompleted():void
        {
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character1_run_right",  new Array("character1_run_right0", "character1_run_right1"), 8, "character1_run_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character1_attack",  new Array("character1_attack0", "character1_attack1") ,8 ,"character1_attack"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character2_run_right",  new Array("character2_run_right0", "character2_run_right1"), 8, "character2_run_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character2_attack",  new Array("character2_attack0", "character2_attack1") ,8 ,"character2_attack"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character3_run_left",  new Array("character3_run_left0", "character3_run_left1"), 8, "character3_run_left"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character3_attack",  new Array("character3_attack0", "character3_attack1") ,8 ,"character3_attack"));
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

        public function get playerCharacterArray():Array
        {
            return _playerCharacterArray;
        }

        public function set playerCharacterArray(value:Array):void
        {
            _playerCharacterArray = value;
        }

        public function get enemyCharacterArray():Array
        {
            return _enemyCharacterArray;
        }

        public function set enemyCharacterArray(value:Array):void
        {
            _enemyCharacterArray = value;
        }
        
        
        
    }
}