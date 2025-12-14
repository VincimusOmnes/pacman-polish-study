shader_type particles;

float rand_from_seed(in uint seed) {
  int k;
  int s = int(seed);
  if (s == 0)
    s = 305420679;
  k = s / 127773;
  s = 16807 * (s - k * 127773) - 2836 * k;
  if (s < 0)
    s += 2147483647;
  seed = uint(s);
  return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = ((x >> uint(16)) ^ x) * uint(73244475);
  x = (x >> uint(16)) ^ x;
  return x;
}

void start() {
	uint alt_seed1 = hash(NUMBER + uint(1) + RANDOM_SEED);
	uint alt_seed2 = hash(NUMBER + uint(27) + RANDOM_SEED);
	uint alt_seed3 = hash(NUMBER + uint(43) + RANDOM_SEED);
	uint alt_seed4 = hash(NUMBER + uint(111) + RANDOM_SEED);

	CUSTOM.x = rand_from_seed(alt_seed1);
	float angle = rand_from_seed(alt_seed1) * TAU;
	float radius = sqrt(rand_from_seed(alt_seed2)) * 0.02;
	vec3 position = vec3(cos(angle) * radius,
	                     0,
	                     0);
	

	TRANSFORM[3].xyz = position * 2.0;
	VELOCITY.x = (rand_from_seed(alt_seed2) * 2.0 - 1.0) * 0.3;
	VELOCITY.y = (rand_from_seed(alt_seed3) * 2.0 - 1.0) * 0.3;
	// Rotation speed
	CUSTOM.y = rand_from_seed(alt_seed4) * 10.0;
	float start_scale = 0.1;
    TRANSFORM[0].xyz = normalize(TRANSFORM[0].xyz) * start_scale;
    TRANSFORM[1].xyz = normalize(TRANSFORM[1].xyz) * start_scale;
    TRANSFORM[2].xyz = normalize(TRANSFORM[2].xyz) * start_scale;
	
	CUSTOM.w = 0.0;
}

void process() {
    // Update rotation angle
    CUSTOM.x = CUSTOM.y * DELTA;
	CUSTOM.w += DELTA;
    // Rotate around Y-axis
    float angle = CUSTOM.x;
    float c = cos(angle);
    float s = sin(angle);

    // Store the original transform columns
    vec3 x_axis = TRANSFORM[0].xyz;
    vec3 z_axis = TRANSFORM[2].xyz;

    // Apply Y-axis rotation while preserving scale and other transforms
    TRANSFORM[0].xyz = x_axis * c + z_axis * s;
    TRANSFORM[2].xyz = z_axis * c - x_axis * s;
	
	COLOR.a = 1.0 - smoothstep(0.7, 1.0, CUSTOM.w / LIFETIME);
}