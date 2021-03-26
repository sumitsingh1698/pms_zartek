class Milestones {
  List<Milestone> milestone;

  Milestones({this.milestone});

  Milestones.fromJson(Map<String, dynamic> json) {
    if (json['milestone'] != null) {
      milestone = new List<Milestone>();
      json['milestone'].forEach((v) {
        milestone.add(new Milestone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.milestone != null) {
      data['milestone'] = this.milestone.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Milestone {
  String appUrl;
  String description;
  bool started;
  String entityType;
  String completedAtOverride;
  String startedAt;
  String completedAt;
  String name;
  bool completed;
  String state;
  String startedAtOverride;
  String updatedAt;
  // List<Null> categories;
  int id;
  int position;
  Stats stats;
  String createdAt;

  Milestone(
      {this.appUrl,
        this.description,
        this.started,
        this.entityType,
        this.completedAtOverride,
        this.startedAt,
        this.completedAt,
        this.name,
        this.completed,
        this.state,
        this.startedAtOverride,
        this.updatedAt,
        // this.categories,
        this.id,
        this.position,
        this.stats,
        this.createdAt});

  Milestone.fromJson(Map<String, dynamic> json) {
    appUrl = json['app_url'];
    description = json['description'];
    started = json['started'];
    entityType = json['entity_type'];
    completedAtOverride = json['completed_at_override'];
    startedAt = json['started_at'];
    completedAt = json['completed_at'];
    name = json['name'];
    completed = json['completed'];
    state = json['state'];
    startedAtOverride = json['started_at_override'];
    updatedAt = json['updated_at'];
    // if (json['categories'] != null) {
    //   categories = new List<Null>();
    //   json['categories'].forEach((v) {
    //     categories.add(new Null.fromJson(v));
    //   });
    // }
    id = json['id'];
    position = json['position'];
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_url'] = this.appUrl;
    data['description'] = this.description;
    data['started'] = this.started;
    data['entity_type'] = this.entityType;
    data['completed_at_override'] = this.completedAtOverride;
    data['started_at'] = this.startedAt;
    data['completed_at'] = this.completedAt;
    data['name'] = this.name;
    data['completed'] = this.completed;
    data['state'] = this.state;
    data['started_at_override'] = this.startedAtOverride;
    data['updated_at'] = this.updatedAt;
    // if (this.categories != null) {
    //   data['categories'] = this.categories.map((v) => v.toJson()).toList();
    // }
    data['id'] = this.id;
    data['position'] = this.position;
    if (this.stats != null) {
      data['stats'] = this.stats.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Stats {
  int numRelatedDocuments;

  Stats({this.numRelatedDocuments});

  Stats.fromJson(Map<String, dynamic> json) {
    numRelatedDocuments = json['num_related_documents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_related_documents'] = this.numRelatedDocuments;
    return data;
  }
}
