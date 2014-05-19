package com.sundaytoz.st2D.display
{
    import flash.geom.Matrix3D;
    

    /**
     * 스프라이트들을 관리하고 화면에 출력합니다. 
     */
    public class SpriteController
    {        
        private var _sprites:Array = new Array();
        
        /**
         * 사용한 자원을 해제합니다. 
         */
        public function dispose():void
        {
            for each( var sprite:STSprite in _sprites )
            {
                (sprite as STSprite).dispose();
                sprite = null;
            }
        }
       
        /**
         * 화면에 출력할 스프라이트를 추가합니다. 
         */
        public function addSprite(sprite:STSprite):void
        {            
            _sprites.push(sprite);
            
            // depth 로 sorting ( depth가 같으면 zOrder 로 Sorting )
            if( _sprites.length >= 2)
            {
                _sprites.sort(sortingWithDepth);
            }
        }
        
        /**
         * 모든 스프라이트가 담긴 벡터를 반환합니다. 
         */
        public function getAllSprites():Array
        {
            return _sprites;
        }
        
        /**
         * 스프라이트 벡터에서 스프라이트를 삭제합니다.  
         * @param sprite    삭제할 스프라이트
         */
        internal function removeSprite(sprite:STSprite):void
        {
            for( var i:uint = 0; i<_sprites.length; ++i)
            {
                if( _sprites[i] == sprite )
                {
                    _sprites.splice(i, 1);
                }
            }
        }
        
        private function sortingWithDepth(lhs:STSprite, rhs:STSprite):int
        {
            if( lhs.depth < rhs.depth )
            {
                return -1;
            }
            else if( lhs.depth > rhs.depth )
            {
                return 1;
            }
            else
            {
                if( lhs.zOrder < rhs.zOrder )
                {
                    return -1;
                }
                else if( lhs.zOrder > rhs.zOrder )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
        }
        
    }
}