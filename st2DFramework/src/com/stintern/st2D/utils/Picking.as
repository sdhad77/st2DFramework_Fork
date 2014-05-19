package com.stintern.st2D.utils
{
	import com.stintern.st2D.basic.StageContext;
	import com.stintern.st2D.display.sprite.STSprite;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	public class Picking
	{
		public function Picking()
		{
		}
        
        /// todo STSprite의 깊이 문제 추가 (), allSprite상에서 해결하면 불필요 @구현모
        /**
         * 
         * @param stage 터치가 일어난 stage
         * @param allSprite 출력된 STSprite Array
         * @param x 터치된 stage x좌표
         * @param y 터치된 stage y좌표
         * @return allSprite의 STSprite 중 터치된 좌표상에 있는 STSprite
         * 
         */
		public static function pick(stage:Stage, allSprite:Array, x:Number, y:Number): STSprite
		{
            var xUnit:Number = x;
            var yUnit:Number = Math.abs(y - stage.stageHeight);     //stage좌표와 context3d좌표 차이 수정

			var picked:STSprite;
			for each (var sprite:STSprite in allSprite)
			{
				var rect:Rectangle = new Rectangle(sprite.position.x - (sprite.width/2), sprite.position.y - (sprite.height/2), sprite.width, sprite.height);
                
				if (!rect.contains(xUnit,yUnit))
				{
					continue;
				}
				picked = sprite;
			}
			return picked;
		}
        
        public static function touchPosition(x:Number, y:Number):Vector2D
        {
            var stage:Stage = StageContext.instance.stage;
            
            var xUnit:Number = x;
            var yUnit:Number = Math.abs(y - stage.stageHeight);     //stage좌표와 context3d좌표 차이 수정
            
            return new Vector2D(xUnit, yUnit)
        }
	}
}
