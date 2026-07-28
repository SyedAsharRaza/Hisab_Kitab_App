// owed to me and i owe them
enum LedgerDirection {
  theyOweMe, // receivable
  iOweThem, // payable
}

// ek ledger ka status
enum LedgerStatus {
  pending,
  settled,
}

// ui state jo Providers istemal kar rahe hayn
enum ViewStatus {
  initial,
  loading,
  success,
  error,
}

extension LedgerDirectionX on LedgerDirection {
  bool get isReceivable => this == LedgerDirection.theyOweMe;

  String get label =>
      this == LedgerDirection.theyOweMe ? 'They owe me' : 'I owe them';
}