import 'package:example/src/domain/entity/time_control.dart';

const sampleData = {
  TimeControlType.bullet: [
    TimeControl.noIncrement(givenTimeInMinutes: 1),
    TimeControl.fischer(givenTimeInMinutes: 1, bonusTimeInSeconds: 1),
    TimeControl.fischer(givenTimeInMinutes: 2, bonusTimeInSeconds: 1, favourite: true),
  ],
  TimeControlType.blitz: [
    TimeControl.noIncrement(givenTimeInMinutes: 3, favourite: true),
    TimeControl.fischer(givenTimeInMinutes: 3, bonusTimeInSeconds: 2, favourite: true),
    TimeControl.noIncrement(givenTimeInMinutes: 5),
    TimeControl.fischer(givenTimeInMinutes: 5, bonusTimeInSeconds: 5),
  ],
  TimeControlType.rapid: [
    TimeControl.noIncrement(givenTimeInMinutes: 10, favourite: true),
    TimeControl.fischer(givenTimeInMinutes: 15, bonusTimeInSeconds: 10, favourite: true),
    TimeControl.noIncrement(givenTimeInMinutes: 30),
    TimeControl.noIncrement(givenTimeInMinutes: 60),
  ],
  TimeControlType.classic: [
    TimeControl.noIncrement(givenTimeInMinutes: 60),
  ],
};
