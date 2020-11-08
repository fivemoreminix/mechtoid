shader_type canvas_item;

void fragment() {
	vec4 p = texture(TEXTURE, UV.xy);
	if (p.a <= 0.0) discard;
	float s = sin(TIME * 2.0 + UV.x / UV.y);
	COLOR = mix(vec4(s), p * MODULATE, 0.5);
//	vec3 s = vec3(sin(TIME + UV.x / UV.y));
//	COLOR = mix(vec4(s, 0.0), p * MODULATE, 0.5);
}