package com.sundaytoz.st2D.animation.datatype
{
    import flash.display.Bitmap;

    /**
     * 스프라이트 시트에 존재 하는 각각의 이미지들을 Frame 단위로 나눠서 저장하기 위한 클래스입니다. 
     * @author 신동환
     */
    public class AnimationFrame
    {
        private var _name:String;
        private var _x:int;
        private var _y:int;
        private var _width:int;
        private var _height:int;
        private var _frameX:int;
        private var _frameY:int;
        private var _frameWidth:int;
        private var _frameHeight:int;
        private var _bitmap:Bitmap;
        
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
        public function AnimationFrame(name:String, x:int, y:int, width:int, height:int, frameX:int, frameY:int, frameWidth:int, frameHeight:int)
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
        
        public function get name():String     {return _name;}
        public function get x():int           {return _x;}
        public function get y():int           {return _y;}
        public function get width():int       {return _width;}
        public function get height():int      {return _height;}
        public function get frameX():int      {return _frameX;}
        public function get frameY():int      {return _frameY;}
        public function get frameWidth():int  {return _frameWidth;}
        public function get frameHeight():int {return _frameHeight;}
        public function get bitmap():Bitmap   {return _bitmap;}
        
        public function set name(value:String):void     {_name        = value;}
        public function set x(value:int):void           {_x           = value;}
        public function set y(value:int):void           {_y           = value;}
        public function set width(value:int):void       {_width       = value;}
        public function set height(value:int):void      {_height      = value;}
        public function set frameX(value:int):void      {_frameX      = value;}
        public function set frameY(value:int):void      {_frameY      = value;}
        public function set frameWidth(value:int):void  {_frameWidth  = value;}
        public function set frameHeight(value:int):void {_frameHeight = value;}
        public function set bitmap(value:Bitmap):void   {_bitmap      = value;}
    }
}