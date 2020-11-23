


class CurrentStatus{

   String end;
   String prjname;
   String status;
  int per;



CurrentStatus({
  this.end,
  this.prjname,
  this.status,
  this.per,

});

CurrentStatus.fromMap(Map<String , dynamic> data)
:this(
  end: data['end_date'],
  prjname: data['project_name'],
  status: data['status'],
  per: data['percentage'],
  
);
}