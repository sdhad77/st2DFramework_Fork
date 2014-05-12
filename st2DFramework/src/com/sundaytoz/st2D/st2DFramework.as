package com.sundaytoz.st2D
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DRenderMode;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    
    public class st2DFramework extends Sprite
    {
        public function st2DFramework()
        {
            super();
            
            // support autoOrients
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
			stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initStage3D );
			stage.stage3Ds[0].addEventListener( ErrorEvent.ERROR, requestErrorHandler);
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
			
			
		}
		
		private function requestErrorHandler(e:ErrorEvent):void
		{
			trace("Error message : " + e.toString());
		}
		
		private function initStage3D(e:Event):void
		{
			
		}
		
    }
}