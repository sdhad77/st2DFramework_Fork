package com.stintern.st2D.demo
{
    import com.stintern.st2D.LayerSample.utils.Resources;
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.AnimationFrame;
    import com.stintern.st2D.basic.StageContext;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.Vector2D;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.Event;
    
    /**
     * 자동으로 이동하는 구름을 배경으로 사용할 수 있게하는 레이어입니다.
     * @author "신동환"
     */
    public class GameBGCloud extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _cloud:Vector.<Sprite> = new Vector.<Sprite>;
        private var _cloudIdx:int = 0;
        private var _sch:Scheduler = new Scheduler;
        private var _totalWidth:int;
        private var _cloudNum:int;
        private var _totalMoveSec:Number;
        private var _scale:Number;
        
        private var _cloudMovePixelPerSecond:int;
        
        /**
         * 자동 구름 생성 레이어 초기화 함수입니다.</br>
         * 구름의 이동속도를 픽셀/초 단위로 입력할 수 있습니다.
         * @param pixelPerSecond 구름의 이동속도를 픽셀/초 단위
         */
        public function GameBGCloud(pixelPerSecond:int = 45)
        {
            super();
            
            _cloudMovePixelPerSecond = pixelPerSecond;
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath(Resources.PATH_SPRITE_BACKGROUND, Resources.PATH_XML_BACKGROUND, loadCompleted, null, false);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {
            //구름의 가로세로 길이가 필요함.
            var cloudFrame:AnimationFrame = AnimationData.instance.animationData[Resources.PATH_SPRITE_BACKGROUND]["frame"]["cloud"];
            //구름의 스케일 조정을 위한 변수
            _scale = StageContext.instance.screenHeight/4/cloudFrame.height;
            //맵의 전체길이
            _totalWidth = StageContext.instance.screenWidth;
            //구름이 맵을 이동하는데 걸리는 시간
            _totalMoveSec = (_totalWidth + cloudFrame.width*_scale) / _cloudMovePixelPerSecond;
            //구름의 출발 간격. 연달아서 출발하도록 하였음
            var startSec:Number = cloudFrame.width*_scale / _cloudMovePixelPerSecond;
            
            //필요한 구름 갯수만큼 구름 생성
            for(var i:int = 0; i < Math.ceil(_totalMoveSec / startSec); i++)
            {
                _cloud.push(new Sprite);
                _cloud[_cloud.length-1].createSpriteWithBatchSprite(_batchSprite, "cloud", -cloudFrame.width, StageContext.instance.screenHeight + cloudFrame.height);
                _cloud[_cloud.length-1].setScale(new Vector2D(_scale,_scale));
                _cloud[_cloud.length-1].isVisible = false;
                _batchSprite.addSprite(_cloud[_cloud.length-1]);
            }
            
            cloudFrame = null;
            
            //초단위에서 밀리초 단위로 변경
            _totalMoveSec *= 1000;
            startSec *= 1000;
            
            //첫번째 구름 출발
            _sch.addFunc(0, cloudMoveStart, 1);
            //그 이후 자동적으로 구름 출발 시킴
            _sch.addFunc(startSec, cloudMoveStart, 0);
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
            _cloud[_cloudIdx].setTranslation(new Vector2D(-_cloud[_cloudIdx].width/2*_scale, StageContext.instance.screenHeight + Math.random()*_cloud[_cloudIdx].height/4*_scale));
            _cloud[_cloudIdx].isVisible = true;
            _cloud[_cloudIdx].moveBy(_totalWidth + _cloud[_cloudIdx].width*_scale, 0, _totalMoveSec);
            _cloudIdx++;
        }
    }
}