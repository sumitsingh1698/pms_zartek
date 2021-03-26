
class ProjectStatus {
  int count;
  Null next;
  Null previous;
  List<Results> results;

  ProjectStatus({this.count, this.next, this.previous, this.results});

  ProjectStatus.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int id;
  String project;
  String description;
  int client;
  String startDate;
  String endDate;
  int completedStatus;
  String paymentStatus;
  String dropboxLink;
  String projectmanagerNumber;
  List<Document> document;
  List<Invoices> invoices;

  Results(
      {this.id,
        this.project,
        this.description,
        this.client,
        this.startDate,
        this.endDate,
        this.completedStatus,
        this.paymentStatus,
        this.dropboxLink,
        this.document,
        this.invoices,this.projectmanagerNumber});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectmanagerNumber= json['project_manager_number'];
    project = json['Project'];
    description = json['description'];
    client = json['client'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    completedStatus = json['completed_status'];
    paymentStatus = json['payment_status'];
    dropboxLink = json['dropbox_link'];

    if (json['document'] != null) {
      document = new List<Document>();
      json['document'].forEach((v) {
        document.add(new Document.fromJson(v));
      });
    }
    if (json['invoices'] != null) {
      invoices = new List<Invoices>();
      json['invoices'].forEach((v) {
        invoices.add(new Invoices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Project'] = this.project;
    data['description'] = this.description;
    data['client'] = this.client;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['completed_status'] = this.completedStatus;
    data['payment_status'] = this.paymentStatus;
    data['dropbox_link'] = this.dropboxLink;
    data['project_manager_number'] = this.projectmanagerNumber;
    if (this.document != null) {
      data['document'] = this.document.map((v) => v.toJson()).toList();
    }
    if (this.invoices != null) {
      data['invoices'] = this.invoices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Document {
  int id;
  String name;
  String documents;

  Document({this.id, this.name, this.documents});

  Document.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    documents = json['documents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['documents'] = this.documents;
    return data;
  }
}

class Invoices {
  int id;
  String name;
  String invoice;

  Invoices({this.id, this.name, this.invoice});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    invoice = json['invoice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['invoice'] = this.invoice;
    return data;
  }
}
