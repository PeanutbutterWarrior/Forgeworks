shader_type spatial;
render_mode unshaded, cull_front;

uniform float thickness;
uniform sampler2D mask;

void vertex() {
	VERTEX += VERTEX * thickness;
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