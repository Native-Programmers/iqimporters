import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class Countdown extends StatelessWidget {
  int time;
  Countdown({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CountdownTimer(
          endTime: time,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) {
              return const Text('Waiting for Admin to start draw');
            } else {
              return Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${time.days ?? '00'}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 10,
                      ),
                      Text(
                        "DAY",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    width: 15,
                    color: Colors.transparent,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${time.hours ?? '00'}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 10,
                      ),
                      Text(
                        "HOUR",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    width: 15,
                    color: Colors.transparent,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${time.min ?? '00'}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 10,
                      ),
                      Text(
                        "MIN",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    width: 15,
                    color: Colors.transparent,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${time.sec ?? '00'}',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 10,
                      ),
                      Text(
                        "SEC",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
