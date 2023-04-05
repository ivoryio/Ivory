import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  TransferCubit() : super(TransferInitial());
}
