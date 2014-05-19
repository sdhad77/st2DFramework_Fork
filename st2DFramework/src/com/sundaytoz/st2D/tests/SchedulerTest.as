package com.sundaytoz.st2D.tests
{
    import com.sundaytoz.st2D.animation.AnimationManager;
    import com.sundaytoz.st2D.display.Layer;
    import com.sundaytoz.st2D.display.sprite.STSprite;
    import com.sundaytoz.st2D.utils.scheduler.Scheduler;

    /**
     * 스케줄러 테스트 Layer입니다.
     * @author 구현모
     * 
     */
    public class SchedulerTest extends Layer
    {
        private var sprite1:STSprite = new STSprite();
        private var _i:int=1;
        
        public function SchedulerTest()
        {
            
            var sch:Scheduler = new Scheduler();
            sch.addFunc(2000, createStar, 4);
            sch.startScheduler();
            
            function createStar():void
            {
                STSprite.createSpriteWithPath("res/star.png", onCreated, null, _i*80, 128);
                _i++;
            }
        }
        
        private function onCreated(sprite:STSprite):void
        {
            sprite1 = sprite;
            this.addSprite(sprite1);
        }
        
        override public function update(dt:Number):void
        {
            AnimationManager.instance.update();
        }
    }
}