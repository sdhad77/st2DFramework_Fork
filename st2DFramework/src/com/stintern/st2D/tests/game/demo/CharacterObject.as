package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.SpriteAnimation;

    public class CharacterObject
    {
        private var _info:CharacterInfo;
        private var _characterMovingLayer:CharacterMovingLayer = SceneManager.instance.getCurrentScene().getLayerByName("CharacterMovingLayer") as CharacterMovingLayer;
        private var _backGroundLayer:BackGroundLayer = SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer;
        private var _batchSprite:BatchSprite;
        private var _sprite:SpriteAnimation;
        
        public static const RUN:String = "RUN";
        public static const ATTACK:String = "ATTACK";
         
        
        public function CharacterObject(path:String, hp:Number, power:Number, speed:Number, ally:Boolean)
        {
            _info = new CharacterInfo(hp, power, speed, ally);
            _batchSprite = _characterMovingLayer.batchSprite;

            onCreated();
        }

        private function onCreated():void
        {
            _sprite = new SpriteAnimation();
            var x:Number = 0;
            var y:Number = 0;
            _sprite.createAnimationSpriteWithPath("res/dungGame.png", "char", onSpriteCreated, null, x, y );
        }
        
        private function onSpriteCreated():void
        {
            _sprite.setScaleWithWidthHeight(StageContext.instance.screenHeight/5, StageContext.instance.screenHeight/5);
            if(_info.ally == true)
            {
                _sprite.position.x = 0;
                _sprite.position.y = _sprite.height*3;
                _batchSprite.addSprite(_sprite);
                _sprite.moveTo(StageContext.instance.screenWidth * _backGroundLayer.bgPageNum, _sprite.height*3, _info.speed);
            }
            else
            {
                _sprite.position.x = StageContext.instance.screenWidth * _backGroundLayer.bgPageNum;
                _sprite.position.y = _sprite.height*3;
                _batchSprite.addSprite(_sprite);
                _sprite.moveTo(0, _sprite.height*3, _info.speed);
            }
            _sprite.playAnimation();
        }

        public function get sprite():SpriteAnimation
        {
            return _sprite;
        }

        public function get info():CharacterInfo
        {
            return _info;
        }

        public function set info(value:CharacterInfo):void
        {
            _info = value;
        }
    }
}
import com.stintern.st2D.tests.game.demo.CharacterObject;


class CharacterInfo
{
    private var _hp:Number;
    private var _power:Number;
    private var _speed:Number
    private var _ally:Boolean;
    private var _state:String;
    
    public function CharacterInfo(hp:Number, power:Number, speed:Number, ally:Boolean)
    {
        _hp = hp;
        _power = power;
        _speed = speed;
        _ally = ally;
        _state = CharacterObject.RUN;
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

    public function get state():String
    {
        return _state;
    }

    public function set state(value:String):void
    {
        _state = value;
    }
}