class SeatDetailModel {
  final String? row;
  final String? column;
  final String? status;

  SeatDetailModel(
    this.row,
    this.column,
    this.status,
  );

  factory SeatDetailModel.fromJson(Map<String, dynamic> json) {
    return SeatDetailModel(
      json['row'],
      json['column'],
      json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'column': column,
      'status': status,
    };
  }
}
