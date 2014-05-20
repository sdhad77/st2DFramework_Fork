package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.STAnimation;

    public class CharacterObject
    {
        
        private var _sprite:STAnimation = new STAnimation();
        private var _info:CharacterInfo;
        private var _layer:Layer;
        
        public function CharacterObject(layer:Layer, path:String, hp:Number, power:Number, speed:Number, ally:Boolean)
        {
            _layer = layer;
            _info = new CharacterInfo(hp, power, speed, ally);
            _sprite.createAnimationSpriteWithPath(path, "char", onCreated, null, 0, 60);
        }
        
        private function onCreated():void
        {
            _layer.addSprite(_sprite);
            _sprite.moveTo(1024, 60, _info.speed);
            _sprite.playAnimation();
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