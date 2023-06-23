/// Simple TimeControl entity.
class TimeControl {
  const TimeControl.noIncrement({required int givenTimeInMinutes, bool favourite = false})
      : this._(
          incrementType: IncrementType.noIncrement,
          givenTimeInMinutes: givenTimeInMinutes,
          bonusTimeInSeconds: 0,
          favourite: favourite,
        );

  const TimeControl.fischer({required int givenTimeInMinutes, required int bonusTimeInSeconds, bool favourite = false})
      : this._(
            incrementType: IncrementType.fisher,
            givenTimeInMinutes: givenTimeInMinutes,
            bonusTimeInSeconds: bonusTimeInSeconds,
            favourite: favourite);

  const TimeControl._({
    required this.incrementType,
    required this.givenTimeInMinutes,
    required this.bonusTimeInSeconds,
    this.favourite = false,
  });

  final IncrementType incrementType;
  final int givenTimeInMinutes;
  final int bonusTimeInSeconds;
  final bool favourite;

  TimeControlType get type => TimeControlType.forGivenTime(givenTimeInMinutes);
}

enum IncrementType {
  noIncrement,
  fisher,
}

/// Type of chess games.
enum TimeControlType {
  bullet(0, 3),
  blitz(3, 10),
  rapid(10, 61),
  classic(61);

  const TimeControlType(this.closedLowerBound, [this.openUpperBound]);

  /// Find the type for a givenTimeInMinutes.
  static TimeControlType forGivenTime(int givenTimeInMinutes) {
    for (final type in values) {
      final upperBound = type.openUpperBound;
      if (upperBound == null || givenTimeInMinutes < upperBound) {
        return type;
      }
    }
    return TimeControlType.values.last;
  }

  final int closedLowerBound;
  final int? openUpperBound;
}
