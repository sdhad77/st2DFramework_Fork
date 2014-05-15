package com.sundaytoz.st2D.display
{
    public class Scene
    {
        // 싱글톤 관련 변수들
        private static var _instance:Scene;
        private static var _creatingSingleton:Boolean = false;
        
        private var _layerArray:Array = new Array();
        
        public function Scene()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():Scene
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new Scene();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        /**
         * 모든 레이어의 update 함수를 호출합니다.
         */
        public function updateAllLayers():void
        {
            for(var i:uint=0; i<_layerArray.length; ++i)
            {
                (_layerArray[i] as Layer).update();
            }
        }
        
        /**
         * 특정 레이어의 update 함수를 호출합니다.
         * @param layer update 함수를 호출할 layer
         */
        public function updateLayer(layer:Layer):void
        {
            if( layer == null )
            {
                throw new Error("updateLayer() : layer is null");
            }
            
            layer.update();
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
            
    }
}