package com.stintern.st2D.display
{
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.STObject;
    import com.stintern.st2D.display.sprite.STSprite;
    import com.stintern.st2D.display.sprite.SpriteController;

    /**
     * 하나의 층을 나타내는 Layer 클래스입니다. 
     * 사용자는 Layer 클래스를 상속받아 사용자 만의 Layer를 만들고
     * 스프라이트를 생성하여 상속받은 Layer클래스의 addSprite() 를 사용하여
     * Layer 객체에 추가하면 다음 프레임 때부터 스프라이트가 화면에 출력됩니다.
     * 
     * <br/>
     * 
     * BatchSprite 배열을 이용하여 화면 출력의 효율을 높일 수도 있습니다.
     * 
     * <br/>
     * 
     * Layer의 dispose 함수를 이용해서 Layer가 사용한 자원을 해제할 경우에는
     * Layer가 포함되었던 Scene에서 Layer를 삭제해주십시오
     * 
     * @see also BatchSprite   
     * @author 이종민
     * 
     */
    public class Layer extends STObject  
    {
        private var _spriteManager:SpriteController = new SpriteController();
        private var _batchSpriteArray:Array = new Array();
        
        public function Layer()
        {
        }
        
        public function update(dt:Number):void
        {
            throw new Error("Layer 클래스는 update()추상함수를 포함합니다. 오버라이딩 해주세요 ");
        }
        
        /**
         * 레이어를 삭제하면서 사용한 자원을 해제합니다.
         * <b>반드시 삭제한 레이어를 현재 레이어가 포함된 Scene 에서 제거해주십시오.</b>
         * 
         * (Bitmap 관련 데이터는 AsserLoader 객체에 남아있으니 필요없으면 AsserLoader 를 통해서 삭제해주십시오.) 
         */
        public function dispose():void
        {
            if( _spriteManager != null )
            {
                _spriteManager.dispose();
            }
            _spriteManager = null;
            
            if( _batchSpriteArray != null )
            {
                for each(var batchSprite:BatchSprite in _batchSpriteArray)
                {
                    if( batchSprite != null )
                    {
                        batchSprite.dispose();
                    }
                    _batchSpriteArray.splice(batchSprite, 1);
                }
            }
            
            _batchSpriteArray = null;
        }
        
        /**
         * 레이어에 새로운 스프라이트를 추가합니다. 
         * @param sprite 새롭게 추가할 스프라이트
         */
        public function addSprite(sprite:STSprite):void
        {
            _spriteManager.addSprite(sprite);
        }
        
        /**
         * BatchSprite 를 추가합니다. 
         */
        public function addBatchSprite(batchSprite:BatchSprite):void
        {
            _batchSpriteArray.push(batchSprite);
        }
        
        /**
         * 추가된 BatchSprite 를 제거합니다. 
         * BatchSprite 객체가 사용한 자원도 해제됩니다.
         * (AssetLoader 에 저장되어 있는 Bitmap 관련 데이터는 남아있습니다.)
         */
        public function removeBatchSprite(batchSprite:BatchSprite):void
        {
            for(var i:uint=0; i<_batchSpriteArray.length; ++i)
            {
                if( _batchSpriteArray[i] == batchSprite )
                {
                    (_batchSpriteArray[i] as BatchSprite).dispose();
                    _batchSpriteArray.splice(i, 1);
                    break;
                }
            }
        }

        
        /**
         * 레이어에 있는 스프라이트를 제거합니다. 
         * @param sprite 제거할 스프라이트 객체
         */
        public function removeSprite(sprite:STSprite):void
        {
            _spriteManager.removeSprite(sprite);
            sprite.dispose();
        }  
        
        /**
         * 레이어의 스프라이트 배열을 반환합니다.
         */
        public function getAllSprites():Array
        {
            if( _spriteManager == null )
                return null;
            
            return _spriteManager.getAllSprites();
        }
        
        /**
         * 레이어에 사용중인 batchSprite 배열을 리턴합니다. 
         */
        public function get batchSpriteArray():Array
        {
            return _batchSpriteArray;
        }
                
    }
}