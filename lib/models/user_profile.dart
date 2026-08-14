/// Biological sex, used only to pick a Widmark distribution factor for the
/// blood-alcohol estimate — see [AlcoholCalculator].
enum Sex { male, female, other }

/// The bio details used to personalize the blood-alcohol estimate on the
/// Alcohol tab. None of this is used anywhere else in the app.
class UserProfile {
  const UserProfile({
    required this.sex,
    required this.age,
    required this.weightKg,
  });

  static const UserProfile defaults = UserProfile(
    sex: Sex.other,
    age: 30,
    weightKg: 70,
  );

  final Sex sex;
  final int age;
  final double weightKg;

  UserProfile copyWith({Sex? sex, int? age, double? weightKg}) {
    return UserProfile(
      sex: sex ?? this.sex,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}
