String fahrenheitToCelsius(double fahrenheit) {
  return ((fahrenheit - 32) * 5 / 9).toString();
}

class GDPData {
  GDPData(this.temp);

  final int temp;
}
