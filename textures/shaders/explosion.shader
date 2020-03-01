shader_type canvas_item;

uniform int multiplier = 4;
uniform vec2 size = vec2(64., 26.);

varying float mult;

void vertex() {
	if (multiplier > 0) {
		mult = float(multiplier * 2);
		VERTEX *= mult;
	}
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (multiplier > 0) {
		vec2 uv = fract(UV * size); // 0 - 1 for each pixel of the texture
		float d = 0.5 / mult;
		if (uv.x < 0.5 - d || uv.x > 0.5 + d || uv.y < 0.5 - d || uv.y > 0.5 + d)
			COLOR.a = 0.;
	}
}