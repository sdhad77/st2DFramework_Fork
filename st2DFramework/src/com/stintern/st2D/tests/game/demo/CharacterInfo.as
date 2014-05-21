package com.stintern.st2D.tests.game.demo
{
    public class CharacterInfo
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
        
        public function set hp(value:Number):void
        {
            _hp = value;
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
}