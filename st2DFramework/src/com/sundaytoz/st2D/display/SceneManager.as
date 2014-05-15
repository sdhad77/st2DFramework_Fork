package com.sundaytoz.st2D.display
{
    public class SceneManager
    {
        // 싱글톤 관련 변수들
        private static var _instance:SceneManager;
        private static var _creatingSingleton:Boolean = false;
        
        private var _sceneVector:Vector.<Scene> = new Vector.<Scene>();
        
        public function SceneManager()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():SceneManager
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new SceneManager();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        /**
         * 현재 Scene 을 새로운 Scene 으로 교체합니다. <br/>
         * 이전 Scene 은 삭제됩니다. 
         * @param scene 교체할 새로운 Scene
         */
        public function changeCurrentScene(scene:Scene):void
        {
            _sceneVector.pop().clean();
            _sceneVector.push(scene);
        }
        
        /**
         * 새로운 Scene 을 추가합니다. 이전 Scene 은 그대로 보존됩니다. 
         * @param scene 추가할 Scene 
         */
        public function pushScene(scene:Scene):void
        {
            if( _sceneVector.length != 0 && _sceneVector[_sceneVector.length-1] == scene )
                return;
            
            _sceneVector.push(scene);
        }
        
        /**
         * 이전에 사용하던 Scene 으로 되돌아 갑니다. 
         */
        public function popScene():void
        {
            if( _sceneVector.length == 1 )
            {
                throw new Error("현재 Scene 이 하나밖에 존재하지 않습니다.");
            }
            
            _sceneVector.pop();
        }
        
        /**
         * 현재 사용하고 있는 Scene 을 반환합니다. 
         */
        public function getCurrentScene():Scene
        {
            return _sceneVector[_sceneVector.length-1];
        }
        
        /**
         * 현재 저장되어 있는 Scene 의 개수를 반환합니다. 
         */
        public function getSceneCount():uint
        {
            return _sceneVector.length;
        }
    }
}