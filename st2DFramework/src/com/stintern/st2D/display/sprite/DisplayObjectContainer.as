package com.stintern.st2D.display.sprite
{
    public class DisplayObjectContainer extends DisplayObject
    {
        private var _displayObject:Array;
        
        public function DisplayObjectContainer()
        {
        }
        
        public function addChild(child:DisplayObject):void
        {
            if( _displayObject == null )
            {
                _displayObject = new Array();
            }
            
            _displayObject.push(child);
        }
        
        public function removeChildAt(index:uint):void
        {
            _displayObject.splice(index, 1);
        }
        
        public function removeChildByName(name:String):void
        {
            for(var i:uint=0; i<_displayObject.length; ++i)
            {
                if( _displayObject[i].name == name )
                {
                    _displayObject.splice(i, 1);
                    break;
                }
            }
        }
        
        public function removeChildByTag(tag:uint):void
        {
            for(var i:uint=0; i<_displayObject.length; ++i)
            {
                if( _displayObject[i].tag == tag )
                {
                    _displayObject.splice(i, 1);
                    break;
                }
            }
        }
        
        public function getAllChildren():Array
        {
            return _displayObject;
        }
        
        public function getChildAt(index:uint):DisplayObject
        {
            return _displayObject[index];
        }
        
        public function hasChild():Boolean
        {
            if( _displayObject == null )
                return false;
            
            return _displayObject.length > 0 ? true : false; 
        }
    }
}