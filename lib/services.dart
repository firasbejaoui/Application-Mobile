import 'data.dart' as data;

void addCar(value) {
  data.cars.add(value);
}

void updateCar(ref, value) {
  data.cars[data.cars.indexWhere((element) => element['ref'] == ref)] = value;
}

List getAllCars() {
  return data.cars;
}

Map<String, dynamic> getCar(ref) {
  return data.cars.firstWhere((element) => element['ref'] == ref);
}

void removeCar(ref) {
  data.cars.removeWhere((element) => element['ref'] == ref);
}
