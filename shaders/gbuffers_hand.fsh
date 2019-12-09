#version 120

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform mat4 gbufferModelViewInverse;
uniform vec4 entityColor;
uniform vec3 shadowLightPosition;
uniform vec3 skyColor;
uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec3 world;
varying vec2 coord0;
varying vec2 coord1;
varying float id;

void main()
{
    vec3 dir = normalize((gbufferModelViewInverse * vec4(shadowLightPosition,0)).xyz);
    float flip = clamp(dir.y/.1,-1.,1.); dir *= flip;
    vec3 norm = normalize(cross(dFdx(world),dFdy(world)));
    float lambert = (id>1.)?dir.y*.5+.5:dot(norm,dir)*.5+.5;

    //float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    //clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);
    vec3 shad = mix(skyColor*.5+.2,vec3(1),lambert) * texture2D(lightmap,coord1).rgb;

    vec4 col = texture2D(texture,coord0);
    col *= color * vec4(shad*(1.-blindness),1);
    //col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);
    col.rgb = mix(col.rgb,entityColor.rgb,entityColor.a);
    gl_FragData[0] = col;
}
