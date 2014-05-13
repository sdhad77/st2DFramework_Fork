package com.sundaytoz.st2D.basic
{
    import com.adobe.utils.AGALMiniAssembler;
    import com.adobe.utils.PerspectiveMatrix3D;
    
    import flash.display.Stage;
    import flash.display.Stage3D;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;
    import flash.events.Event;
    import flash.geom.Matrix3D;

    public class StageContext
    {
        // 싱글톤 관련 변수들
        private static var _instance:StageContext;
        private static var _creatingSingleton:Boolean = false;
        
        private var _context3D:Context3D;
        private var _shaderProgram:Program3D;
        
        private var _projectionMatrix:Matrix3D;
        private var _viewMatrix:Matrix3D = new Matrix3D();
        
        public function StageContext()
        {
            if (!_creatingSingleton){
                throw new Error("[Context] 싱글톤 클래스 - new 연산자를 통해 생성 불가");
            }
        }
        
        public static function get instance():StageContext
        {
            if (!_instance){
                _creatingSingleton = true;
                _instance = new StageContext();
                _creatingSingleton = false;
            }
            return _instance;
        }
        
        public function init(stage:Stage, onInited:Function):void
        {
            stage.frameRate = 60;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
            stage.stage3Ds[0].requestContext3D();
                
            function onContext3DCreate(event:Event):void 
            {
                var t:Stage3D = event.target as Stage3D;					
                _context3D = t.context3D; 	
                
                if (_context3D == null) 
                {
                    return;
                }
                
                _context3D.enableErrorChecking = true;
                _context3D.configureBackBuffer(stage.fullScreenWidth, stage.fullScreenHeight, 2, true); //(2=antialiased)
                
                initShaders();
                
                //_projectionMatrix.identity();
                _projectionMatrix = createOrthographicProjectionMatrix(0.0, stage.fullScreenWidth, 0.0, stage.fullScreenHeight, -1024, 1024);
                
                _viewMatrix.identity();
                _viewMatrix.appendTranslation(-stage.fullScreenWidth/2, -stage.fullScreenHeight/2, 1);
                
                
                onInited();
            }
        }
        
        private function createOrthographicProjectionMatrix(left:Number, right:Number, bottom:Number, top:Number, near:Number, far:Number):Matrix3D
        {
            return new Matrix3D(Vector.<Number>
                ([
                    2/(right-left), 0, 0, 0,
                    0, 2/(top-bottom), 0, 0,
                    0, 0, 2/(far-near), -near/(far-near),
                    0, 0, 0, 1
                ]));
        }
        
        private function initShaders():void
        {
            var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexShaderAssembler.assemble
                ( 
                    Context3DProgramType.VERTEX,
                    // 4x4 matrix multiply to get camera angle	
                    "m44 op, va0, vc0\n" +
                    // tell fragment shader about XYZ
                    "mov v0, va0\n" +
                    // tell fragment shader about UV
                    "mov v1, va1\n" +
                    // tell fragment shader about RGBA
                    "mov v2, va2\n"
                );			
            
            var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentShaderAssembler.assemble
                ( 
                    Context3DProgramType.FRAGMENT,	
                    "tex ft0, v1, fs0 <2d,linear,repeat,miplinear>\n" +	
                    "mov oc, ft0\n"									
                );
            
            _shaderProgram = _context3D.createProgram();
            _shaderProgram.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
        }
        
        /** property */
        
        public function get context():Context3D
        {
            return _context3D;
        }
        
        public function get shaderProgram():Program3D
        {
            return _shaderProgram;
        }

        public function get projectionMatrix():Matrix3D
        {
            return _projectionMatrix;
        }
        
        public function get viewMatrix():Matrix3D
        {
            return _viewMatrix;
        }

    }
}