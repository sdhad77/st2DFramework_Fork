package com.stintern.st2D.display
{
    import com.stintern.st2D.display.sprite.STObject;

    public class Scene extends STObject
    {
        private var _layerArray:Array = new Array();
        
        /**
         * 모든 레이어의 update 함수를 호출합니다.
         */
        public function updateAllLayers(dt:Number):void
        {
            for(var i:uint=0; i<_layerArray.length; ++i)
            {
                (_layerArray[i] as Layer).update(dt);
            }
        }
        
        /**
         * Scene 객체가 가지고 있는 Layer Array 에 새로운 레이어를 추가합니다. 
         * @param layer 추가할 레이어
         * 
         */
        public function addLayer(layer:Layer):void
        {
            _layerArray.push(layer);
        }
        
        public function get layerArray():Array
        {
            return _layerArray;
        }
        
        public function clean():void
        {
            
        }
            
    }
}