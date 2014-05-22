package com.stintern.st2D.tests.game.demo
{
    import com.stintern.st2D.animation.AnimationData;
    import com.stintern.st2D.animation.datatype.Animation;
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
            _batchSprite.createBatchSpriteWithPath("res/demo/demo_spritesheet.png", "res/demo/demo_atlas.xml", onCompleted);
            addBatchSprite(_batchSprite);
        }
        
        private function onCompleted():void
        {
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character1_run_right",    new Array("character1_run_right0",    "character1_run_right1"),    8, "character1_run_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character1_attack",       new Array("character1_attack0",       "character1_attack1"),       8 ,"character1_attack"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character2_run_right",    new Array("character2_run_right0",    "character2_run_right1"),    8, "character2_run_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character2_attack_right", new Array("character2_attack_right0", "character2_attack_right1"), 8 ,"character2_attack_right"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character3_run_left",     new Array("character3_run_left0",     "character3_run_left1"),     8, "character3_run_left"));
            AnimationData.instance.setAnimation("res/demo/demo_spritesheet.png", new Animation("character3_attack_left",  new Array("character3_attack_left0",  "character3_attack_left1"),  8 ,"character3_attack_left"));
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