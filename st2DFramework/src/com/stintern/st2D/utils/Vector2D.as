package com.stintern.st2D.utils
{
    public class Vector2D
    {
        private var _x:Number;
        private var _y:Number;
        
        public function Vector2D(x:Number = 0, y:Number = 0)
        {
            _x = x;
            _y = y;
        }
        
        public function get x():Number
        {
            return _x;
        }
        public function set x(x:Number):void
        {
            _x = x;
        }
        
        public function get y():Number
        {
            return _y;
        }
        public function set y(y:Number):void
        {
            _y = y;
        }
    }
}