   mod_test_shader      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                mod_test_shader.vs�  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;

attribute vec4 POS2D_UV;

varying vec3 PS_TEXCOORD;

void main()
{
    vec3 POSITION = vec3(POS2D_UV.xy, 0);
    float samplerIndex = floor(POS2D_UV.z/2.0);
    vec3 TEXCOORD0 = vec3(POS2D_UV.z - 2.0*samplerIndex, POS2D_UV.w, samplerIndex);

    mat4 mtxPVW = MatrixP * MatrixV * MatrixW;
    gl_Position = mtxPVW * vec4( POSITION.xyz, 1.0 );

    PS_TEXCOORD = TEXCOORD0;
}    mod_test_shader.psS  #ifdef GL_ES
precision mediump float;
#endif

// uniform float u_time;
// uniform vec2 u_resolution;  /// area size

// DST 
uniform vec4 TIMEPARAMS;    // u_time == TIMEPARAMS.x 
varying vec3 PS_TEXCOORD;   // data from .vs file


// vec3 colorA = vec3(0.149,0.141,0.912);
// vec3 colorB = vec3(1.0,0.833,0.224);
void main(){
    // vec2 st = gl_FragCoord.xy/u_resolution;  //[0~1]
    // gl_FragColor = vec4(st.x,st.y,1,1);


    vec2 u_resolution = vec2(PS_TEXCOORD.x,PS_TEXCOORD.y);
    vec2 st = gl_FragCoord.xy/u_resolution;
    gl_FragColor = vec4(st.x,st.y,0,1);
}                  