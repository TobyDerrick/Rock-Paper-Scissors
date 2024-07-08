shader_type canvas_item;

uniform float dot_count: hint_range(0, 100, 1);
uniform float dot_strength: hint_range(0.0, 1.0, 0.1);

void fragment(){
	vec2 uv = UV;
    
    uv *= 2.0;
    uv -= vec2(1.0);
	
	vec2 cells = vec2(dot_count * uv.x, dot_count * uv.y);
	
	vec2 d = fract(cells);
	float dist_to_center = length(d - 0.5);
	
	float inverse_dist_to_center =  1.0 - dist_to_center;
	float inverse_dot_strength = 1.0 - dot_strength;
	float fin = (inverse_dist_to_center - inverse_dot_strength) / dot_strength;
	
	COLOR = vec4(vec3( clamp(fin, 0.0, 1.0)), 1.0);
	
}