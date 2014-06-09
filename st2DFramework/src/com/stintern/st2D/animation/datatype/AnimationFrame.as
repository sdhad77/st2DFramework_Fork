package com.stintern.st2D.animation.datatype
{
    /**
     * 스프라이트 시트에 존재 하는 각각의 이미지들을 Frame 단위로 나눠서 저장하기 위한 클래스입니다. 
     * @author 신동환
     */
    public class AnimationFrame
    {
        private var _name:String;
        private var _x:Number;
        private var _y:Number;
        private var _width:Number;
        private var _height:Number;
        private var _frameX:Number;
        private var _frameY:Number;
        private var _frameWidth:Number;
        private var _frameHeight:Number;
        
        /**
         * Frame 생성자입니다.
         * @param name Frame의 이름
         * @param x 스프라이트 시트에서 Frame의 x 좌표
         * @param y 스프라이트 시트에서 Frame의 y 좌표
         * @param width 스프라이트 시트에서 Frame의 가로 길이
         * @param height 스프라이트 시트에서 Frame의 세로 길이
         * @param frameX 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 x 좌표
         * @param frameY 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 y 좌표
         * @param frameWidth 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 가로 길이
         * @param frameHeight 스프라이트 시트 만들 때 공백을 자르기 전, 원래 이미지에서의 Frame의 세로 길이
         */
        public function AnimationFrame(name:String, x:Number, y:Number, width:Number, height:Number, frameX:Number, frameY:Number, frameWidth:Number, frameHeight:Number)
        {
            _name = name;
            _x = x;
            _y = y;
            _width = width;
            _height = height;
            _frameX = frameX;
            _frameY = frameY;
            _frameWidth = frameWidth;
            _frameHeight = frameHeight;
        }
        
        public function get name():String        {return _name;        }
        public function get x():Number           {return _x;           }
        public function get y():Number           {return _y;           }
        public function get width():Number       {return _width;       }
        public function get height():Number      {return _height;      }
        public function get frameX():Number      {return _frameX;      }
        public function get frameY():Number      {return _frameY;      }
        public function get frameWidth():Number  {return _frameWidth;  }
        public function get frameHeight():Number {return _frameHeight; }
        
        public function set name(value:String):void        {_name        = value;}
        public function set x(value:Number):void           {_x           = value;}
        public function set y(value:Number):void           {_y           = value;}
        public function set width(value:Number):void       {_width       = value;}
        public function set height(value:Number):void      {_height      = value;}
        public function set frameX(value:Number):void      {_frameX      = value;}
        public function set frameY(value:Number):void      {_frameY      = value;}
        public function set frameWidth(value:Number):void  {_frameWidth  = value;}
        public function set frameHeight(value:Number):void {_frameHeight = value;}
    }
}