import '../../../../core/enums/app_enums.dart';

// domain level
class LedgerEntryEntity {
  final String id;
  final String userId; // is ledger record ka owner
  final String personName;
  final double amount;
  final String note;
  final LedgerDirection direction;
  final LedgerStatus status;
  final DateTime createdAt;
  final DateTime? settledAt;

  const LedgerEntryEntity({
    required this.id,
    required this.userId,
    required this.personName,
    required this.amount,
    required this.note,
    required this.direction,
    required this.status,
    required this.createdAt,
    this.settledAt,
  });

  bool get isSettled => status == LedgerStatus.settled;
  bool get isPending => status == LedgerStatus.pending;

  LedgerEntryEntity copyWith({
    LedgerStatus? status,
    DateTime? settledAt,
  }) {
    return LedgerEntryEntity(
      id: id,
      userId: userId,
      personName: personName,
      amount: amount,
      note: note,
      direction: direction,
      status: status ?? this.status,
      createdAt: createdAt,
      settledAt: settledAt ?? this.settledAt,
    );
  }
}