package com.stintern.st2D.display
{
    import com.stintern.st2D.display.sprite.Base;

    public class Scene extends Base
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
        
        /**
         * Scene 에서 Layer 를 삭제합니다.  
         * Layer를 삭제하면서 Layer에 담긴 Sprite 등의 자원도 해제합니다.
         */
        public function removeLayer(layer:Layer):void
        {
            for(var i:uint=0; i<_layerArray.length; ++i)
            {
                if( (_layerArray[i] as Layer) == layer )
                {
                    (_layerArray[i] as Layer).dispose();
                    _layerArray.splice(i, 1);
                    break;
                }
            }
        }
        
        public function get layerArray():Array
        {
            return _layerArray;
        }
        
        /**
         * 태그를 통해서 특정 레이어를 반환합니다. 
         * @param tag 찾을 레이어의 태그
         * @return 태그를 가진 레이어 ( 없을 경우 null 리턴 )
         */
        public function getLayerByTag(tag:uint):Layer
        {
            for each(var layer:Layer in _layerArray)
            {
                if( layer.tag == tag )
                    return layer;
            }
            
            return null;
        }
        
        /**
         * 이름을 통해서 특정 레이어를 반환합니다. 
         * @param name 찾을 레이어의 이름
         * @return name을 가진 레이어 ( 없을 경우 null 리턴 )
         */
        public function getLayerByName(name:String):Layer
        {
            for each(var layer:Layer in _layerArray)
            {
                if( layer.name == name )
                    return layer;
            }
            
            return null;
        }
        
        /**
         * 사용한 Scene 을 해제합니다. Scene이 포함하고 있는 Layer 및 Sprite 들을 모두 해제합니다.
         * Sprite 들이 가지고 있는 Bitmap 데이터는 해제되지 않고 AssetLoader 객체가 보관합니다.  
         * Bitmap 객체를 모두 지우려면 AssetLoader 를 통해서 삭제하십시오.
         */
        public function dispose():void
        {
            for(var i:uint=0; i<_layerArray.length; ++i)
            {
                (_layerArray[i] as Layer).dispose();
                _layerArray.splice(i, 1);
            }
        }
            
    }
}