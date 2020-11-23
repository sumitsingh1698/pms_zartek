class Milestone {
  String title;
  String description;
  int completedStatus;
  String paymentStatus;
  String startDate;
  String endDate;
  String milestoneDetails;
  String dropboxLink;

  Milestone(
      {this.title,
        this.description,
        this.completedStatus,
        this.paymentStatus,
        this.startDate,
        this.endDate,
        this.milestoneDetails,
        this.dropboxLink});

  Milestone.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    completedStatus = json['completed_status'];
    paymentStatus = json['payment_status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    milestoneDetails = json['milestone_details'];
    dropboxLink = json['dropbox_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['completed_status'] = this.completedStatus;
    data['payment_status'] = this.paymentStatus;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['milestone_details'] = this.milestoneDetails;
    data['dropbox_link'] = this.dropboxLink;
    return data;
  }
}
