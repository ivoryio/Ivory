import 'package:equatable/equatable.dart';

class TransferAuthorizationRequest extends Equatable {
  final String id;
  final String status;
  final String? stringToSign;
  final String confirmUrl;

  const TransferAuthorizationRequest({
    required this.id,
    required this.status,
    required this.confirmUrl,
    this.stringToSign,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        stringToSign,
        confirmUrl,
      ];
}
