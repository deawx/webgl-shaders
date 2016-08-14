precision highp float;

// WIDTH, HEIGHT, C_REAL, C_IMAGINARY, X_MIN, X_MAX, Y_MIN, Y_MAX
uniform float data[16];

float WIDTH      = data[0];
float HEIGHT     = data[1];

float C_REAL     = data[2];
float C_IMAG     = data[3];

float BRIGHTNESS = data[4]; // 800 range

float X_MIN      = data[5];
float X_MAX      = data[6];
float Y_MIN      = data[7];
float Y_MAX      = data[8];

float SUPERSAMPLES = data[9];

float COLORSET = data[10];
float FRACTAL = data[11];
float iGlobalTime = data[12];
float EXPONENT = data[13];
float ANGLE1 = data[14];
float ANGLE2 = data[15];

const int MAX_ITERATIONS = 30;
const float pi = 3.1415926;

float X_RANGE = X_MAX - X_MIN;
float Y_RANGE = Y_MAX - Y_MIN;

vec2 iResolution = vec2(WIDTH, HEIGHT);
vec2 iPixelSize  = vec2(X_RANGE / WIDTH, Y_RANGE / HEIGHT);

vec2 msaaCoords[16];

struct complex {
  float real;
  float imaginary;
};

vec2 cmult(vec2 a, vec2 b) {
  return vec2(
    a.x * b.x - a.y * b.y,
    a.x * b.y + a.y * b.x
  );
}

vec2 cexp(vec2 vector) {
  float magnitude = exp(vector.x);
  float argument  = vector.y;

  float real = magnitude * cos(argument);
  float imag = magnitude * sin(argument);

  return vec2(real, imag);
}

vec2 rotate(vec2 vector, float theta) {
  float magnitude = length(vector);
  float argument  = atan(vector.y, vector.x);

  float real = magnitude * cos(argument + theta);
  float imag = magnitude * sin(argument + theta);

  return vec2(real, imag);
}

vec2 ccos(vec2 c) {
  vec2 ci = cmult(c, vec2(0, 1));
  vec2 c1 = rotate(ci, ANGLE1);
  vec2 c2 = -rotate(ci, ANGLE2);

  return (cexp(c1) + cexp(c2)) / 2.0;
}

float collatz(vec2 position) {
  vec2 z = position;

  for (int iteration = 0; iteration < MAX_ITERATIONS; iteration++) {
    float thing = 10.0 * sin(iGlobalTime / 2000.0) + 5.0;
    z = (vec2(1.0, 0.0) + EXPONENT * z - cmult(vec2(1.0,0.0) + 2.0 * z, ccos(pi * z))) / 4.0;

    if (length(z) > BRIGHTNESS) {
      return float(iteration);
    }
  }

  return 0.0;
}

vec2 fragCoordToXY(vec4 fragCoord) {
  vec2 relativePosition = fragCoord.xy / iResolution.xy;
  float aspectRatio = iResolution.x / HEIGHT;

  vec2 center = vec2((X_MAX + X_MIN) / 2.0, (Y_MAX + Y_MIN) / 2.0);

  vec2 cartesianPosition = (relativePosition - 0.5) * (X_MAX - X_MIN);
  cartesianPosition.x += center.x;
  cartesianPosition.y -= center.y;
  cartesianPosition.x *= aspectRatio;

  return cartesianPosition;
}

void main() {
  vec2 coordinate = fragCoordToXY(gl_FragCoord);

  // float color = log(collatz(coordinate)) / log(float(MAX_ITERATIONS));
  float color = collatz(coordinate);

  gl_FragColor =  vec4(sin(color / 1.0), sin(color / 3.0), sin(color / 5.0), 1.0);
}
