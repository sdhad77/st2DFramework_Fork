package com.stintern.st2D.basic
{
    import com.adobe.utils.PerspectiveMatrix3D;
    import com.stintern.st2D.utils.Resources;
    
    import flash.geom.Matrix3D;

    public class Camera
    {
        private var _x:Number = 0.0, _y:Number = 0.0;
        private var _width:Number = 0.0, _height:Number = 0.0;
        
        private var _projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
        private var _viewMatrix:Matrix3D = new Matrix3D();
        
        public function Camera()
        {
            _viewMatrix.identity();
            _projectionMatrix.identity();
        }
        
        /**
         * 카메라의 위치를 초기화합니다. 
         * @param x 카메라의 좌측 좌표 
         * @param y 카메라의 하단 좌표
         * @param width 카메라가 비출 화면의 가로 길이 
         * @param height 카메라가 비출 화면의 세로 길이
         * 
         */
        public function init(x:Number, y:Number, width:Number, height:Number):void
        {
          _x = x;
          _y = y;
          _width = width;
          _height = height;
          
          _viewMatrix.appendTranslation(_x, _y, 0);
          _projectionMatrix.orthoRH(_width, _height, Resources.MIN_DEPTH, Resources.MAX_DEPTH);
          
        }
        
        /**
         * 카메라를 특정 방향으로 옮김니다. (카메라의 위치는 누적해서 이동됩니다. ) <br/>
         * 즉 처음 위치가 (0, 0) 이었을 때  moveCamera(1.0, 1.0) 를 하면 <br/>
         * 카메라의 위치는 (1.0, 1.0)이 되고 이어서 moveCamera(2.0, 2.0) 를 호출하면<br/>
         * 카메라의 위치는 (3.0, 3.0)이 됩니다.<br/>
         *  
         * @param vector 이동할 방향
         * 
         */
        public function moveCamera(x:Number, y:Number):void
        {
            _x += x;
            _y += y;
            
            _viewMatrix.identity();
            _viewMatrix.appendTranslation(_x, _y, 0);
            
        }
        
        /**
         * 카메라를 줌인 및 아웃 시킵니다. (누적해서 줌 인/아웃이 일어납니다.)<br/>
         * 초기 상태에서 zoom(2.0, 2.0)을 하면 좌, 우 2배씩 늘어나게 됩니다.<br/>
         * 그 상태에서 다시 zoom(2.0, 2.0) 을 하면 4배가 됩니다.<br/>
         * 
         * ( param > 1.0 : 줌 인, param < 1.0 : 줌 아웃 ) <br/>
         *   
         * @param scaleX X축으로 줌 인/아웃 시킬 양   
         * @param scaleY Y축으로 줌 인/아웃 시킬 양
         */
        public function zoom(scaleX:Number, scaleY:Number):void
        {
            _width *= 1/scaleX;
            _height *= 1/scaleY;
            
            _projectionMatrix.identity();
            _projectionMatrix.orthoRH(_width, _height, Resources.MIN_DEPTH, Resources.MAX_DEPTH);
        }
        
        public function get x():Number
        {
            return _x;
        }
        public function get y():Number
        {
            return _y;
        }
        
        internal function get projection():Matrix3D
        {
            return _projectionMatrix;
        }
        internal function get view():Matrix3D
        {
            return _viewMatrix;
        }
    }
}