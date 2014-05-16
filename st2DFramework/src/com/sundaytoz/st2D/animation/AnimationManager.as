package com.sundaytoz.st2D.animation
{
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.animation.datatype.AnimationFrame;
    import com.sundaytoz.st2D.animation.datatype.AnimationPlayData;
    import com.sundaytoz.st2D.display.STSprite;
    import com.sundaytoz.st2D.utils.Vector2D;
    
    import flash.utils.Dictionary;

    /**
     * 재생중인 애니메이션 전체를 관리하는 클래스입니다.
     * @author 신동환
     */
    public class AnimationManager
    {
        // 싱글톤 관련 변수들
        private static var _instance:AnimationManager;
        private static var _creatingSingleton:Boolean = false;
        
        private var _playSprite:Dictionary = new Dictionary; //sprite의 uv좌표를 바꿔주기 위해 sprite를 저장해 두어야 합니다.
        private var _playAnimationData:Dictionary = new Dictionary; //재생중인 애니메이션들의 데이터 입니다.
        private var _isPlaying:Boolean = true; //전체 애니메이션의 재생을 통제하기 위한 변수입니다.
        
        public function AnimationManager()
        {
            if (!_creatingSingleton){
                throw new Error("[AnimationManager] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():AnimationManager
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new AnimationManager();
                _creatingSingleton = false;
            }
            return _instance;
        }

        /**
         * 애니메이션을 사용하겠다고 Sprite를 등록하는 함수입니다. 
         * @param sprite 애니메이션을 사용하고 싶은 Sprite
         * @param animationName 사용할 애니메이션의 이름
         */
        public function addSprite(sprite:STSprite, animationName:String):void
        {
            _playSprite[sprite] = sprite;
            _playAnimationData[sprite] = new AnimationPlayData(AnimationData.instance.animationData[sprite.path], animationName);
            _playAnimationData[sprite].isPlaying = true;
        }
        
        /**
         * 애니메이션을 다음 프레임으로 이동 시킵니다. 
         */
        private function nextFrame(idx:STSprite):AnimationFrame
        {
            var playAnimation:Animation = _playAnimationData[idx].getPlayAnimation(_playAnimationData[idx].playAnimationName);
           
            //현재 애니메이션 프레임 유지할 경우.
            if(_playAnimationData[idx].delayCnt < playAnimation.delayNum[_playAnimationData[idx].playAnimationFlowIdx])
            {
                _playAnimationData[idx].delayCnt++;
                
                return AnimationData.instance.animationData[_playSprite[idx].path]["frame"][playAnimation.animationFlow[_playAnimationData[idx].playAnimationFlowIdx]];
            }
            //유지 시간(pauseFrameCnt)이 다되서 다음 프레임으로 넘어갈 때
            else
            {
                //FlowIdx 가 0부터 시작이라서 -1을 해줘야 합니다.
                //아직 다음으로 넘어갈 프레임이 존재하는 경우. 즉 애니메이션이 종료되지 않았을때
                if(_playAnimationData[idx].playAnimationFlowIdx < (playAnimation.animationFlow.length-1))
                {
                    _playAnimationData[idx].delayCnt = 0;
                    _playAnimationData[idx].playAnimationFlowIdx++;
                    
                    return AnimationData.instance.animationData[_playSprite[idx].path]["frame"][playAnimation.animationFlow[_playAnimationData[idx].playAnimationFlowIdx]];
                }
                //현재 애니메이션이 완료되어 다음 애니메이션으로 넘어가야 할 때
                else
                {
                    _playAnimationData[idx].playAnimationName = playAnimation.nextAnimationName;
                    _playAnimationData[idx].delayCnt = 0;
                    _playAnimationData[idx].playAnimationFlowIdx = 0;
                    
                    return nextFrame(idx);
                }
            }
            //여기까진 절대 오지 말아야 하며 오면 무조건 에러입니다.
            return null;
        }
        
        /**
         * update에서 호출되는 함수로, STSprite를 이동시켜야 할 경우 이동시키는 함수입니다. 
         * @param idx 이동시켜야할지 검사할 STSprite입니다.
         */
        private function move(idx:STSprite):void
        {
            //움직이는 중이면
            if(_playAnimationData[idx].isMoving)
            {
                //원하는 지점에 도달 하였으면
                if((Math.abs(_playAnimationData[idx].destX - idx.position.x) <= 1) && (Math.abs(_playAnimationData[idx].destY - idx.position.y) <= 1)) 
                {
                    _playAnimationData[idx].isMoving = false;
                }
                //원하는 지점에 아직 도달하지 못했으면
                else
                {
                    //매 프레임 움직여야하는 양인 increase를 move에 더해주고,
                    _playAnimationData[idx].moveX += _playAnimationData[idx].increaseX;
                    _playAnimationData[idx].moveY += _playAnimationData[idx].increaseY;
                    
                    //move의 값이 int 타입으로 계산 가능할 때 sprite의 위치를 변경시켜줍니다.
                    //int로 하는 이유는 sprite의 좌표를 정수로 유지하기 위해서 입니다.
                    //bitmap 이미지를 이용해서 애니메이션 하기 때문에 그려지는 좌표가 실수일 경우 그림이 비정상적으로 출력됩니다.(약간 번진듯한 느낌?)
                    if(Math.abs(_playAnimationData[idx].moveX) >= 1)
                    {
                        idx.position.x += Math.floor(_playAnimationData[idx].moveX);
                        _playAnimationData[idx].moveX -= Math.floor(_playAnimationData[idx].moveX);
                    }
                    if(Math.abs(_playAnimationData[idx].moveY) >= 1)
                    {
                        idx.position.y += Math.floor(_playAnimationData[idx].moveY);
                        _playAnimationData[idx].moveY -= Math.floor(_playAnimationData[idx].moveY);
                    }
                }
            }
        }
        
        /**
         * 애니메이션을 업데이트 하는 함수입니다.<br> 
         * 애니메이션이 현재 사용가능한지 확인하고, 사용가능하면 다음 Frame으로 이동시킵니다.
         */
        public function update():void
        {
            var playFrame:AnimationFrame;
            
            //전체 애니메이션 업데이트 중지
            if(_isPlaying == false) return;
            
            for each( var sprite:STSprite in _playSprite )
            {
                //현재 재생중인 상태가 아니면 업데이트 안함
                if(_playAnimationData[sprite].isPlaying == false) continue;
                
                //0,1 -> 현재 이미지,xml 로딩 중, 2 -> 로딩 완료
                if(_playAnimationData[sprite].animationData["available"] == 2)
                {
                    //sprite가 이동중이면 이동시킴
                    move(sprite);
                    
                    //다음 프레임으로 이동
                    playFrame = nextFrame(sprite);
                    
                    //uv좌표 변경하는 방식
                    sprite.frame.width = 32;
                    sprite.frame.height = 32;
                    sprite.setUVCoord(playFrame.x/sprite.textureWidth, playFrame.y/sprite.textureHeight, playFrame.width/sprite.textureWidth, playFrame.height/sprite.textureHeight);
                }
            }
        }
        
        /**
         * 애니메이션을 변경하는 함수입니다.</br>
         * 이 함수를 사용하기 위해서는  addSprite() 함수를 먼저 이용해 sprite를 등록해야 합니다.
         * @param idx 애니메이션을 변경할 STsprite
         * @param name 변경할 애니메이션 이름
         */
        public function setAnimation(idx:STSprite, name:String):void
        {
            if(idx != null) _playAnimationData[idx].setPlayAnimation(name);
        }
           
        /**
         * 특정 좌표로 STSprite를 이동시키는 함수입니다.</br>
         * time으로 이동 거리를 나눈값을 더해서 이동합니다. 
         * @param idx 이동시킬 STSprite
         * @param x 이동할 좌표 x
         * @param y 이동할 좌표 y
         * @param time 몇 번의 프레임에 걸쳐서 이동시킬것인지
         */
        public function moveTo(idx:STSprite, x:int, y:int, second:int):void
        {
            if(idx != null)
            {
                _playAnimationData[idx].isMoving = true;
                _playAnimationData[idx].destX = x;
                _playAnimationData[idx].destY = y;
                _playAnimationData[idx].increaseX = (x - idx.position.x)/(second*60);
                _playAnimationData[idx].increaseY = (y - idx.position.y)/(second*60);
            }
        }
        
        /**
         * 특정 STSprite의 애니메이션을 정지시키는 함수입니다. 
         * @param idx 정지시킬 STSprite
         */
        public function pauseAnimation(idx:STSprite):void
        {
            _playAnimationData[idx].isPlaying = false;
        }

        /**
         * 특정 STSprite의 애니메이션을 재생하는 함수입니다.
         * @param idx 재생할 STSprite
         */
        public function playAnimation(idx:STSprite):void
        {
            _playAnimationData[idx].isPlaying = true;
        }
        
        /**
         * 모든 STSprite의 애니메이션을 정지시키는 함수입니다.</br>
         * 메뉴창을 띄우는 등 애니메이션을 멈춰야 할 일이 있을때 사용하면 되겠습니다.
         */
        public function allPause():void
        {
            _isPlaying = false;
        }
        
        /**
         * allPause로 인해 정지된 애니메이션을 다시 재생하도록 하는 함수입니다.
         */
        public function allPauseCancle():void
        {
            _isPlaying = true;
        }
    }
}