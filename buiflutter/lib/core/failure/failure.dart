// ignore_for_file: public_member_api_docs, sort_constructors_first
class Failure {
  final String error;
  final String? statuscode;

  Failure({required this.error, this.statuscode});


  @override
  String toString() => 'Failure(error: $error, statuscode: $statuscode)';
}
