package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    
    public class CharacterMovingLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        
        private var _playerCharacterArray:Array = new Array();
        private var _enemyCharacterArray:Array = new Array(); 
        
        public function CharacterMovingLayer()
        {
            this.name = "CharacterMovingLayer";
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", null);
            addBatchSprite(_batchSprite);
        }
        
        /**
         * 특정 아군 캐릭터 Object를 제거합니다.
         * @param targetObject 제거할 캐릭터 Object
         */
        public function removePlayerCharacterObject(targetObject:CharacterObject):void
        {
            for(var i:uint=0; i<_playerCharacterArray.length; ++i)
            {
                if( _playerCharacterArray[i] == targetObject )
                {
                    for(var j:uint=0; j<_playerCharacterArray[i].sprite.getAllChildren().length; j++)
                    {
                        var child:Sprite = _playerCharacterArray[i].sprite.getAllChildren()[j];
                        _batchSprite.removeSprite(child);
                        child.dispose();
                    }
                    
                    while(_playerCharacterArray[i].bulletArray.length > 0)
                    {
                        _playerCharacterArray[i].removeBullet(_playerCharacterArray[i].bulletArray.length-1);
                    }

                    _playerCharacterArray.splice(i, 1);
                    break;
                }
            }
        }
        
        /**
         * 특정 적군 캐릭터 Object를 제거합니다.
         * @param targetObject 제거할 캐릭터 Object
         */
        public function removeEnemyCharacterObject(targetObject:CharacterObject):void
        {
            for(var i:uint=0; i<_enemyCharacterArray.length; ++i)
            {
                if( _enemyCharacterArray[i] == targetObject )
                {
                    for(var j:uint=0; j<_enemyCharacterArray[i].sprite.getAllChildren().length; j++)
                    {
                        var child:Sprite = _enemyCharacterArray[i].sprite.getAllChildren()[j];
                        _batchSprite.removeSprite(child);
                        child.dispose();
                    }
                    
                    while(_enemyCharacterArray[i].bulletArray.length > 0)
                    {
                        _enemyCharacterArray[i].removeBullet(_enemyCharacterArray[i].bulletArray.length-1);
                    }
                    
                    _enemyCharacterArray.splice(i, 1);
                    break;
                }
            }
        }
        
        override public function update(dt:Number):void
        {
        }
        
        //get, set 함수들
        public function get batchSprite():BatchSprite    { return _batchSprite;          }
        public function get playerCharacterArray():Array { return _playerCharacterArray; }
        public function get enemyCharacterArray():Array  { return _enemyCharacterArray;  }
        
        public function set batchSprite(value:BatchSprite):void    { _batchSprite = value;          }
        public function set playerCharacterArray(value:Array):void { _playerCharacterArray = value; }
        public function set enemyCharacterArray(value:Array):void  { _enemyCharacterArray = value;  }
    }
}