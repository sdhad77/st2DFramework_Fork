package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;

    public class CharacterObject
    {
        private var _sprite:SpriteAnimation = new SpriteAnimation();
        private var _info:CharacterInfo;
        private var _layer:CharacterMovingLayer = SceneManager.instance.getCurrentScene().getLayerByName("CharacterMovingLayer") as CharacterMovingLayer;
        private var _batchSprite:BatchSprite;
        private var sprite:SpriteAnimation;
         
            
        public function CharacterObject(path:String, hp:Number, power:Number, speed:Number, ally:Boolean)
        {
            _info = new CharacterInfo(hp, power, speed, ally);
            _batchSprite = _layer.batchSprite;

            onCreated();
        }

        private function onCreated():void
        {
            sprite = new SpriteAnimation();
            var x:Number = 0;
            var y:Number = 60;
            sprite.createAnimationSpriteWithPath("res/dungGame.png", "char", onSpriteCreated, null, x, y );
        }
        
        private function onSpriteCreated():void
        {
            _batchSprite.addSprite(sprite);
            sprite.moveTo(1024, 60, _info.speed);
            sprite.playAnimation();
        }
        
        private function onCreated1():void
        {
            _layer.addSprite(_sprite);
        }
    }
}


class CharacterInfo
{
    private var _hp:Number;
    private var _power:Number;
    private var _speed:Number
    private var _ally:Boolean;
    
    public function CharacterInfo(hp:Number, power:Number, speed:Number, ally:Boolean)
    {
        _hp = hp;
        _power = power;
        _speed = speed;
        _ally = ally;
    }

    public function get hp():Number
    {
        return _hp;
    }

    public function get power():Number
    {
        return _power;
    }

    public function get speed():Number
    {
        return _speed;
    }

    public function get ally():Boolean
    {
        return _ally;
    }
}