shader_type spatial;
render_mode unshaded, cull_front;

uniform float thickness;
uniform sampler2D mask;

void vertex() {
	//vec3 vertex = VERTEX * (1.0 + thickness);
	vec3 vertex = VERTEX;
	vec3 normal = normalize(VERTEX);
	
	vec4 view_space = MODELVIEW_MATRIX * vec4(vertex, 1.0);
    vec4 view_space_normal = MODELVIEW_MATRIX * vec4(normal, 0.0);
	
	vec4 clip_space = PROJECTION_MATRIX * view_space;
	vec4 clip_space_normal = PROJECTION_MATRIX * view_space_normal;
	
	vec2 offset = normalize(clip_space_normal.xy) / VIEWPORT_SIZE * clip_space.w * thickness * 2.0;
	
	POSITION = vec4(clip_space.xy + offset, clip_space.zw);
}

void fragment() {
	DEPTH = 0.0;
	ALPHA = 0.0;
	if (texture(mask, SCREEN_UV).r != 1.0) {
		ALBEDO = vec3(1, 1, 1);
		ALPHA = 1.0;
		DEPTH = 0.0;
	}
}