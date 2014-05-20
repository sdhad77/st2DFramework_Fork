package com.stintern.st2D.tests
{
    import com.stintern.st2D.animation.AnimationManager;
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.utils.scheduler.Scheduler;

    /**
     * 스케줄러 테스트 Layer입니다.
     * @author 구현모
     * 
     */
    public class SchedulerTest extends Layer
    {
        private var sprite1:Sprite = new Sprite();
        private var _i:int=1;
        
        public function SchedulerTest()
        {
            
            var sch:Scheduler = new Scheduler();
            sch.addFunc(2000, createStar, 4);
            sch.startScheduler();
            
            function createStar():void
            {
                Sprite.createSpriteWithPath("res/star.png", onCreated, null, _i*80, 128);
                _i++;
            }
        }
        
        private function onCreated(sprite:Sprite):void
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