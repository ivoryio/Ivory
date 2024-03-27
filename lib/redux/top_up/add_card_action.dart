  class SubmitCardInformationCommandAction {
  final String cardHolder;
  final String cardNumber;
  final String month;
  final String year;
  final String cvv;
  
  const SubmitCardInformationCommandAction({
    required this.cardHolder,
    required this.cardNumber,
    required this.month,
    required this.year,
    required this.cvv,
  });
}