package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.display.Layer;
    import com.stintern.st2D.display.Scene;
    import com.stintern.st2D.display.SceneManager;
    import com.stintern.st2D.display.sprite.BatchSprite;
    import com.stintern.st2D.display.sprite.Sprite;
    import com.stintern.st2D.tests.game.LoseLayer;
    import com.stintern.st2D.tests.game.demo.utils.Resources;
    import com.stintern.st2D.tests.game.WinLayer;
    
    public class CharacterMovingLayer extends Layer
    {
        private var _batchSprite:BatchSprite;
        private var _effectBatchSprite:BatchSprite;
        
        private var _playerCharacterArray:Array = new Array();
        private var _enemyCharacterArray:Array = new Array(); 
        
        public function CharacterMovingLayer()
        {
            this.name = "CharacterMovingLayer";
            
            _batchSprite = new BatchSprite();
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", null, null, false);
            addBatchSprite(_batchSprite);
            
            _effectBatchSprite = new BatchSprite();
            _effectBatchSprite.createBatchSpriteWithPath("res/effect.png", "res/effect.xml", null);
            addBatchSprite(_effectBatchSprite);
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
                    winnerCheck(_playerCharacterArray[i]);
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
                    winnerCheck(_enemyCharacterArray[i]);
                    _enemyCharacterArray.splice(i, 1);
                    break;
                }
            }
        }
        
        
        private function winnerCheck(character:CharacterObject):void
        {
            if(character.tag == Resources.TAG_CASTLE)
            {
                var scene:Scene = new Scene();
                if(character.info.ally)
                {
                    var endLayer:LoseLayer = new LoseLayer();
                    scene.addLayer(endLayer);
                }
                else
                {
                    var winLayer:WinLayer = new WinLayer();
                    scene.addLayer(winLayer);
                }
                SceneManager.instance.pushScene(scene);
            }
        }
        
        override public function update(dt:Number):void
        {
        }
        
        //get, set 함수들
        public function get batchSprite():BatchSprite       { return _batchSprite;          }
        public function get playerCharacterArray():Array    { return _playerCharacterArray; }
        public function get enemyCharacterArray():Array     { return _enemyCharacterArray;  }
        public function get effectBatchSprite():BatchSprite { return _effectBatchSprite;    }
        
        public function set batchSprite(value:BatchSprite):void       { _batchSprite          = value; }
        public function set playerCharacterArray(value:Array):void    { _playerCharacterArray = value; }
        public function set enemyCharacterArray(value:Array):void     { _enemyCharacterArray  = value; }
        public function set effectBatchSprite(value:BatchSprite):void { _effectBatchSprite    = value; }
    }
}