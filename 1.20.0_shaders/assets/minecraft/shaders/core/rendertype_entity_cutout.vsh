#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform float FogStart;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

const vec2[4] corners = vec2[4](vec2(-1, 1), vec2(-1, -1), vec2(1, -1), vec2(1, 1));

void main() {
    //gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
	
    #moj_import <flat_item.glsl>

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    //lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
	lightMapColor = minecraft_sample_lightmap(Sampler2, UV2);  // sample lightmap directly for custom color.
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
