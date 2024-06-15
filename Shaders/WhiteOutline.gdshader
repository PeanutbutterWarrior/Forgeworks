shader_type spatial;
render_mode unshaded, cull_front;

uniform float thickness;

void vertex() {
	VERTEX += VERTEX * thickness;
}

void fragment() {
	ALBEDO = vec3(1, 1, 1);
}