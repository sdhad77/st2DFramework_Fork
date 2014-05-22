package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.Event;
    
    /**
     * 자동으로 이동하는 구름을 배경으로 사용할 수 있게하는 레이어입니다.
     * @author "신동환"
     */
    public class CloudLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _cloud:Vector.<Sprite> = new Vector.<Sprite>;
        private var _cloudIdx:int = 0;
        private var _sch:Scheduler = new Scheduler;
        private var _totalWidth:int;
        private var _cloudNum:int;
        private var _totalMoveSec:Number;
        
        private var _cloudMovePixelPerSecond:int;
        
        /**
         * 자동 구름 생성 레이어 초기화 함수입니다.</br>
         * 구름의 이동속도를 픽셀/초 단위로 입력할 수 있습니다.
         * @param pixelPerSecond 구름의 이동속도를 픽셀/초 단위
         */
        public function CloudLayer(pixelPerSecond:int = 45)
        {
            super();
            
            _cloudMovePixelPerSecond = pixelPerSecond;
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", loadCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {
            //맵의 전체길이
            _totalWidth = StageContext.instance.screenWidth * (SceneManager.instance.getCurrentScene().getLayerByName("BackGroundLayer") as BackGroundLayer).bgPageNum;
            //구름이 맵을 이동하는데 걸리는 시간
            _totalMoveSec = (_totalWidth + AnimationData.instance.animationData["res/demo/demo_spritesheet.png"]["frame"]["cloud"].width) / _cloudMovePixelPerSecond;
            //구름의 출발 간격. 연달아서 출발하도록 하였음
            var startSec:Number = AnimationData.instance.animationData["res/demo/demo_spritesheet.png"]["frame"]["cloud"].width / _cloudMovePixelPerSecond;
            
            //필요한 구름 갯수만큼 구름 생성
            for(var i:int = 0; i < Math.ceil(_totalMoveSec / startSec); i++)
            {
                _cloud.push(new Sprite);
                _cloud[i].createSpriteWithBatchSprite(_batchSprite, "cloud");
                _batchSprite.addSprite(_cloud[i]);
                _cloud[i].isVisible = false;
            }
            
            //첫번째 구름 출발
            _sch.addFunc(0, cloudMoveStart, 1);
            //그 이후 자동적으로 구름 출발 시킴
            _sch.addFunc(startSec * 1000, cloudMoveStart, 0);
            _sch.startScheduler();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function cloudMoveStart(evt:Event):void
        {
            //구름을 모두 사용하였으면 처음으로 인덱스를 이동시킴
            if(_cloudIdx == _cloud.length) _cloudIdx = 0;
            
            //구름 위치 세팅하고 출발
            _cloud[_cloudIdx].setTranslation(new Vector2D(-_cloud[_cloudIdx].width/2, StageContext.instance.screenHeight + Math.random()*_cloud[_cloudIdx].height/4));
            _cloud[_cloudIdx].isVisible = true;
            _cloud[_cloudIdx].moveBy(_totalWidth + _cloud[_cloudIdx].width, 0, _totalMoveSec);
            _cloudIdx++;
        }
    }
}