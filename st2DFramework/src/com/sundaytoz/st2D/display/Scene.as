package com.sundaytoz.st2D.display
{
    public class Scene
    {
        // 싱글톤 관련 변수들
        private static var _instance:Scene;
        private static var _creatingSingleton:Boolean = false;
        
        private var _layers:Array = new Array();
        
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
        
        public function addLayer(layer:Layer):void
        {
            _layers.push(layer);
        }
        
        public function get layerArray():Array
        {
            return _layers;
        }
            
    }
}