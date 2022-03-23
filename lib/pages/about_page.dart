import 'package:flutter/material.dart';
import 'package:health_assistant/pages/settings_page.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutPage extends StatefulWidget {
  static const String id = 'about_page';

  @override
  _AboutPage createState() => _AboutPage();
}

const htmlData = """
    <h3 style="text-align: center;">Welcome To <span id="W_Name1">Harmoni</span></h3>
    <p><span id="W_Name2">Harmoni</span> is a Professional <span id="W_Type1">Remote Health Assistant</span> Platform. Here we will provide you with numerous ways to identify risk factors that may bring cardiovascular dieseases into your future. We're dedicated to providing you the best of services regarding your health care. <span id="W_Type2"> The Health Assistant</span>, with a focus on monitoring health related metrics through <span id="W_Spec">risk measurement and management</span>. We're working to turn our passion for <span id="W_Type3">Health Assistant</span> into a booming <a href="https://www.blogearns.com" rel="do-follow" style="color:inherit; text-decoration: none;">Mobile Application </a>. We hope you enjoy our <span id="W_Type4"> creating a remote health Assistant</span> as much as we enjoy offering them to you.</p>
<p style="font-weight: bold; text-align: center;">Thanks For Visiting Our Mobile Application<br><br>
<span style="color: blue; font-size: 16px; font-weight: bold; text-align: center;">Have a nice day !</span></p>
    
""";

class _AboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:
                Text('About Us', style: TextStyle(color: Colors.pink.shade900)),
            leading: IconButton(
              key: Key('AboutUsButton'),
              icon: Icon(
                Icons.chevron_left,
                color: Colors.pink.shade900,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ),
          body: Container(
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                      center: Alignment.centerRight,
                      radius: 2,
                      colors: [
                    Colors.amber.shade50,
                    Colors.pink.shade50,
                    Colors.purple.shade100
                  ])),
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Padding(padding: EdgeInsets.only(top: 70)),
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 5, right: 5)),
                    Html(data: htmlData)
                  ]))),
        ));
  }
}
