package com.stintern.st2D.display.sprite
{
    

    public class STObject 
    {
        private var _tag:uint;
        private var _name:String;
        
        private var _isVisible:Boolean;
        
        public function STObject()
        {
            super();
            _isVisible = true;
        }
        
        public function get name():String
        {
            return _name;
        }
        public function set name(name:String):void
        {
            _name = name;
        }
        
        public function get tag():uint
        {
            return _tag;
        }
        public function set tag(tag:uint):void
        {
            _tag = tag;
        }
        
        public function get isVisible():Boolean
        {
            return _isVisible;
        }
        public function set isVisible(isVisible):void
        {
            _isVisible = isVisible;
        }
    }
}