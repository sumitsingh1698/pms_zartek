class ProjectStatus {
  int projectId;
  String title;
  String description;
  int completedStatus;
  String paymentStatus;
  String startDate;
  String endDate;
  String managerNumber;

  ProjectStatus(
      {this.projectId,
        this.title,
        this.description,
        this.completedStatus,
        this.paymentStatus,
        this.startDate,
        this.endDate,
        this.managerNumber});

  ProjectStatus.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    title = json['title'];
    description = json['description'];
    completedStatus = json['completed_status'];
    paymentStatus = json['payment_status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    managerNumber = json['manager_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['completed_status'] = this.completedStatus;
    data['payment_status'] = this.paymentStatus;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['manager_number'] = this.managerNumber;
    return data;
  }
}
