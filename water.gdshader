shader_type canvas_item;

uniform vec4 color_superficie : source_color = vec4(0.3, 0.6, 0.9, 0.6);
uniform vec4 color_profundo : source_color = vec4(0.1, 0.3, 0.5, 0.9);
uniform vec4 color_espuma : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float grosor_espuma : hint_range(0.0, 0.1) = 0.02;
uniform float suavizado_profundidad : hint_range(0.1, 2.0) = 0.6;

// Textura y movimiento
uniform sampler2D textura_ruido : repeat_enable;
uniform vec2 velocidad_ruido = vec2(0.03, 0.01);
uniform float intensidad_ruido : hint_range(0.0, 1.0) = 0.15;
uniform vec2 escala_ruido = vec2(0.002, 0.002); // Escala pequeña porque ahora usamos píxeles del mundo

// Esta variable recibirá la posición global desde el script
uniform vec2 world_offset = vec2(0.0, 0.0);

void fragment() {
	float y_local = UV.y;
	
	// --- LA SOLUCIÓN: Coordenadas de Mundo ---
	// Combinamos la posición del fragmento en el mundo con el tiempo
	// Usamos (1.0 / TEXTURE_PIXEL_SIZE) para obtener la pos en píxeles si es necesario,
	// pero aquí sumamos el world_offset que enviaremos desde el script.
	vec2 uv_mundo = (UV * 1.0 / TEXTURE_PIXEL_SIZE.xy) + world_offset;
	vec2 uv_final = (uv_mundo * escala_ruido) + (TIME * velocidad_ruido);
	
	float ruido = texture(textura_ruido, uv_final).r;
	
	vec4 color_base = mix(color_superficie, color_profundo, pow(y_local, suavizado_profundidad));
	float brillo = ruido * intensidad_ruido * (1.0 - y_local);
	color_base.rgb += brillo;
	
	float espuma = smoothstep(grosor_espuma, grosor_espuma * 0.5, y_local);
	COLOR = mix(color_base, color_espuma, espuma);
}