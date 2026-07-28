import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/ledger_entry_entity.dart';


// again data layer
class LedgerEntryModel extends LedgerEntryEntity {
  const LedgerEntryModel({
    required super.id,
    required super.userId,
    required super.personName,
    required super.amount,
    required super.note,
    required super.direction,
    required super.status,
    required super.createdAt,
    super.settledAt,
  });

  factory LedgerEntryModel.fromMap(String id, Map<String, dynamic> map) {
    return LedgerEntryModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      personName: map['personName'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      note: map['note'] as String? ?? '',
      direction: LedgerDirection.values[map['direction'] as int? ?? 0],
      status: LedgerStatus.values[map['status'] as int? ?? 0],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      settledAt: (map['settledAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'personName': personName,
      'amount': amount,
      'note': note,
      'direction': direction.index,
      'status': status.index,
      'createdAt': Timestamp.fromDate(createdAt),
      'settledAt': settledAt != null ? Timestamp.fromDate(settledAt!) : null,
    };
  }
  factory LedgerEntryModel.fromEntity(LedgerEntryEntity entity) {
    return LedgerEntryModel(
      id: entity.id,
      userId: entity.userId,
      personName: entity.personName,
      amount: entity.amount,
      note: entity.note,
      direction: entity.direction,
      status: entity.status,
      createdAt: entity.createdAt,
      settledAt: entity.settledAt,
    );
  }
}