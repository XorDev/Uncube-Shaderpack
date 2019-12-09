#version 120

uniform float blindness;

varying vec4 color;

void main()
{
    gl_FragData[0] = color * vec4(vec3(1.-blindness),1);
}
