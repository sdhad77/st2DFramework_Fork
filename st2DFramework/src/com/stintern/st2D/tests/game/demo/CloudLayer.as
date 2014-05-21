package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.scheduler.Scheduler;
    
    import flash.events.Event;
    
    public class CloudLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _cloud:Vector.<Sprite> = new Vector.<Sprite>;
        private var _cloudIdx:int = 0;
        private var _sch:Scheduler = new Scheduler;
        
        public function CloudLayer()
        {
            super();
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", loadCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function loadCompleted():void
        {
            _sch.addFunc(0, createCloud, 1);
            _sch.addFunc(10000, createCloud, 0);
            _sch.startScheduler();
        }
        
        override public function update(dt:Number):void
        {
        }
        
        private function createCloud(evt:Event):void
        {
            _cloud.push(new Sprite);
            _cloud[_cloudIdx].createSpriteWithBatchSprite(_batchSprite, "cloud", -256, 770 + Math.random()*100);
            _batchSprite.addSprite(_cloud[_cloudIdx]);
            _cloud[_cloudIdx].moveBy(4352, 0, 100);
            
            _cloudIdx++;
        }
    }
}