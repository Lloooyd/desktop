class DashboardCountModel {
  int? approvedCount = 0;
  int? completedCount = 0;
  int? forpickupCount = 0;
  int? pendingCount = 0;
  int? rejectedCount = 0;

  DashboardCountModel({
     this.approvedCount,
     this.completedCount,
     this.forpickupCount,
     this.pendingCount,
     this.rejectedCount
  });

  factory DashboardCountModel.fromJson(Map<String, dynamic> json) {
    return DashboardCountModel(
      approvedCount: json['approved_count'],
      completedCount: json['completed_count'],
      forpickupCount: json['forpickup_count'],
      pendingCount: json['pending_count'],
      rejectedCount: json['rejected_count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'approved_count': approvedCount,
      'completed_count': completedCount,
      'forpickup_count': forpickupCount,
      'pending_count': pendingCount,
      'rejected_count': rejectedCount,
    };
  }
}
