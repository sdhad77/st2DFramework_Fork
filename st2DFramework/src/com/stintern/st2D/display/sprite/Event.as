package com.stintern.st2D.display.sprite
{
    import com.stintern.st2D.basic.StageContext;
    
    import flash.utils.Dictionary;

    public class Event
    {
        // 싱글톤 관련 변수들
        private static var _instance:Event;
        private static var _creatingSingleton:Boolean = false;
        
        private var _event:Dictionary = new Dictionary;
        
        public function Event()
        {
            if (!_creatingSingleton){
                throw new Error("[Event] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
            else
            {
                _event["touch"] = new Vector.<Object>;
            }
        }
        
        public static function get instance():Event
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new Event();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        /**
         * 추가되어있는 모든 이벤트를 삭제하는 함수.</br>
         * 현재는 touch 이벤트만 가능하여 임시로 처리해놓았습니다.
         */
        public function clear():void
        {
            while(_event.length)
            {
                _event["touch"][_event.length-1]["sprite"] = null;
                _event["touch"][_event.length-1]["function"] = null;
                _event["touch"].pop();
            }
            
            _event["touch"] = null;
            _event = null;
        }
        
        /**
         * 이벤트 추가 함수
         * @param sprite 이벤트를 추가할 대상
         * @param eventName 추가할 이벤트 이름
         * @param func 이벤트 발생시 호출할 함수
         */
        public function addEventListener(sprite:Sprite, eventName:String, func:Function):void
        {
            var obj:Object = new Object;
            obj["sprite"] = sprite;
            obj["function"] = func;
            
            _event[eventName].push(obj);
            
            obj = null;
        }
        
        /**
         * 이벤트 삭제 함수
         * @param sprite 이벤트를 삭제할 대상
         * @param eventName 제거할 이벤트 이름
         * @param func 제거할 함수이름
         */
        public function removeEventListener(sprite:Sprite, eventName:String, func:Function):void
        {
            for(var i:int=0; i<_event["touch"].length; i++)
            {
                //원하는 것을 찾으면
                if(_event[eventName][i]["sprite"] == sprite && _event[eventName][i]["function"] == func)
                {
                    //삭제!!
                    _event[eventName][i]["sprite"] = null;
                    _event[eventName][i]["function"] = null;
                    _event[eventName].splice(i, 1);
                    
                    break;
                }
            }
        }
        
        public function touchCheck(x:Number, y:Number):void
        {
            var select:Sprite;
            
            for(var i:int=0; i<_event["touch"].length; i++)
            {
                select = _event["touch"][i]["sprite"];
                
                //터치 영역 체크
                if( (select.position.x-select.width/2*select.scale.x) < x && x < (select.position.x+select.width/2*select.scale.x))
                {
                    if(StageContext.instance.screenHeight-(select.position.y+select.height/2*select.scale.x) < y && y < StageContext.instance.screenHeight-(select.position.y-select.height/2*select.scale.x))
                    {
                        //원하는 것을 찾았으면 함수 호출
                        _event["touch"][i]["function"]();
                        break;
                    }
                }
            }
            
            select = null;
        }
    }
}