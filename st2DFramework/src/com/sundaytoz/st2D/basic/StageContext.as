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
        
        private var _projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
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
        
        public function init(stage:Stage):void
        {
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
                _context3D.configureBackBuffer(stage.fullScreenWidth, stage.fullScreenHeight, 0, true);
                
                var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
                vertexShaderAssembler.assemble
                    ( 
                        Context3DProgramType.VERTEX,
                        "m44 op, va0, vc0\n" +
                        "mov v0, va0\n" +
                        "mov v1, va1\n"
                    );			
                
                var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
                fragmentShaderAssembler.assemble
                    ( 
                        Context3DProgramType.FRAGMENT,	
                        "tex ft0, v1, fs0 <2d,repeat,miplinear>\n" +	
                        "mov oc, ft0\n"									
                    );
                
                _shaderProgram = _context3D.createProgram();
                _shaderProgram.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
                
                _projectionMatrix.identity();
                _projectionMatrix.perspectiveFieldOfViewRH(45.0, stage.fullScreenWidth / stage.fullScreenHeight, 0.01, 100.0);
                
                _viewMatrix.identity();
                _viewMatrix.appendTranslation(0,0,-4);
            }
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

        public function get projectionMatrix():PerspectiveMatrix3D
        {
            return _projectionMatrix;
        }
        
        public function get viewMatrix():Matrix3D
        {
            return _viewMatrix;
        }

    }
}