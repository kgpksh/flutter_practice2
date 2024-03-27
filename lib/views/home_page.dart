import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ClipRect(
                child: Stack(
              children: [
                Positioned.fill(child: Container(
                  color: Colors.greenAccent,
                )),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/webApiList'),
                  child: Text('WebApiList'),
                ),
              ],
            )),
            SizedBox(height: 50,),
            ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(
                      color: Colors.greenAccent,
                    )),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/cubitWebApiList'),
                      child: Text('CubitWebApiList'),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
