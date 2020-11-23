import 'package:flutter/material.dart';
import 'package:zartek_pms/widgets/cardview.dart';



class Invoice extends StatefulWidget {
  @override
  Invoice1 createState() => new Invoice1();
}

class Invoice1 extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('YOUR PAYMENTS',
              style: const TextStyle(
                  color: const Color(0xff1e88c6),
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),

        body: CardV(
          page: ProjectPages.invoice,
        ),
      );
    }
  }
}
