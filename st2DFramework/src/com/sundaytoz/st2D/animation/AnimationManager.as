package com.sundaytoz.st2D.animation
{
    import com.sundaytoz.st2D.animation.datatype.Animation;
    import com.sundaytoz.st2D.animation.datatype.AnimationFrame;
    import com.sundaytoz.st2D.animation.datatype.AnimationPlayData;
    import com.sundaytoz.st2D.display.STSprite;
    
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
        
        private var _playSprite:Vector.<STSprite> = new Vector.<STSprite>; //sprite의 uv좌표를 바꿔주기 위해 sprite를 저장해 두어야 합니다.
        private var _playAnimationData:Vector.<AnimationPlayData> = new Vector.<AnimationPlayData>; //재생중인 애니메이션들의 데이터 입니다.
        
        // 이미지 Dictionary
        private var _imageMap:Dictionary = new Dictionary(); 
        
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
            _playSprite.push(sprite);
            _playAnimationData.push(new AnimationPlayData(AnimationData.instance.animationData[sprite.path], animationName));
        }
        
        /**
         * 애니메이션을 다음 프레임으로 이동 시킵니다. 
         */
        public function nextFrame(idx:int):AnimationFrame
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
         * 애니메이션을 업데이트 하는 함수입니다.<br> 
         * 애니메이션이 현재 사용가능한지 확인하고, 사용가능하면 다음 Frame으로 이동시킵니다.
         */
        public function update():void
        {
            var playFrame:AnimationFrame;
            
            if(_playSprite.length)
            {
                for(var i:int = 0; i< _playSprite.length; i++)
                {
                    //0,1 -> 현재 이미지,xml 로딩 중, 2 -> 로딩 완료
                    if(_playAnimationData[i].animationData["available"] == 2)
                    {
                        //다음 프레임으로 이동
                        playFrame = nextFrame(i);

                        //얻은 프레임 정보로 uv좌표를 설정
                        _playSprite[i].setUVCoord(playFrame.x/_playSprite[i].width, playFrame.y/_playSprite[i].height, playFrame.width/_playSprite[i].width, playFrame.height/_playSprite[i].height);
                    }
                }
            }
        }
    }
}