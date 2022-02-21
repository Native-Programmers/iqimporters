import 'package:equatable/equatable.dart';

class Users extends Equatable {
  final String uid;
  final String? email;
  

  const Users(
    this.uid,
    this.email,
  );

  @override
  List<Object?> get props => [uid, email];
}
