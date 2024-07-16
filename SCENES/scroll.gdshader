shader_type canvas_item;

uniform float scroll_speed:hint_range(0.0, 1.0, 0.025);

void vertex(){
	UV.x += TIME * scroll_speed;
	UV.y += TIME * scroll_speed;
}