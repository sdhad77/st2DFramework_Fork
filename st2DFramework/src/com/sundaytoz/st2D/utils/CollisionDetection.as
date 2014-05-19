package com.sundaytoz.st2D.utils
{
    import com.sundaytoz.st2D.display.sprite.STSprite;
    
    import flash.display.Bitmap;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * 
     * @author 구현모
     * collisionCheck를 통해 2개의 STSprite의 충돌 테스틑 함니다.
     * 
     */
    public class CollisionDetection
    {
        public function CollisionDetection()
        {
        }
        
        /**
         * 
         * @param firstSprite 첫번째 충돌체크 대상 STSprite
         * @param secondSprite 두번째 충돌체크 대상 STSprite
         * @return 두개의 STSprite가 충돌시 true 반환, 비충돌시 false 반환.
         * 
         */
        public static function collisionCheck(firstSprite:STSprite, secondSprite:STSprite):Boolean
        {
            if(firstSprite.textureData  == null || secondSprite.textureData == null)
                return false;
            
            var firstBitmap:Bitmap = firstSprite.textureData;
            var rect1:Rectangle = new Rectangle(firstSprite.position.x - (firstSprite.width/2), firstSprite.position.y - (firstSprite.height/2), firstSprite.width, firstSprite.height);
            var rect2:Rectangle = new Rectangle(secondSprite.position.x - (secondSprite.width/2), secondSprite.position.y - (secondSprite.height/2), secondSprite.width, secondSprite.height);
            
            var r1_left_top:Point = new Point(firstSprite.position.x - (firstSprite.width/2), firstSprite.position.y + (firstSprite.height/2));
            var r1_left_bottom:Point = new Point(firstSprite.position.x - (firstSprite.width/2), firstSprite.position.y - (firstSprite.height/2));
            var r1_right_top:Point = new Point(firstSprite.position.x + (firstSprite.width/2), firstSprite.position.y + (firstSprite.height/2));
            var r1_right_bottom:Point = new Point(firstSprite.position.x + (firstSprite.width/2), firstSprite.position.y - (firstSprite.height/2));
            
            var r2_left_top:Point = new Point(secondSprite.position.x - (secondSprite.width/2), secondSprite.position.y + (secondSprite.height/2));
            var r2_left_bottom:Point = new Point(secondSprite.position.x - (secondSprite.width/2), secondSprite.position.y - (secondSprite.height/2));
            var r2_right_top:Point = new Point(secondSprite.position.x + (secondSprite.width/2), secondSprite.position.y + (secondSprite.height/2));
            var r2_right_bottom:Point = new Point(secondSprite.position.x + (secondSprite.width/2), secondSprite.position.y - (secondSprite.height/2));
            
            if(rect2.containsPoint(r1_left_top) || rect2.containsPoint(r1_left_bottom) || rect2.containsPoint(r1_right_top) ||  rect2.containsPoint(r1_right_bottom))
            {
                return true;
            }
            if(rect1.containsPoint(r2_left_top) || rect1.containsPoint(r2_left_bottom) || rect1.containsPoint(r2_right_top) ||  rect1.containsPoint(r2_right_bottom))
            {
                return true;
            }
            
            return false;
        }
    }
}