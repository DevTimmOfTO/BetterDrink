/// Grams of sugar in a drink of the given size and sugar concentration.
double gramsOfSugar({required double volumeMl, required double sugarPer100ml}) {
  return volumeMl * sugarPer100ml / 100;
}
