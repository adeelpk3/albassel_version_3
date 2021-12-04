import 'package:albassel_version_1/helper/api.dart';
import 'package:albassel_version_1/app_localization.dart';
import 'package:albassel_version_1/const/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/background/no_internet.png"),
            //   fit: BoxFit.cover
            // )
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
                App.lightOrange,
                App.orange,
              ],
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              Icon(Icons.wifi_off,size: 100,color: Colors.white,),
              Column(
                children: [
                  Text(App_Localization.of(context).translate("oops"),style: App.textBlod(Colors.white, 32),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(App_Localization.of(context).translate("no_internet"),style: App.textNormal(Colors.white, 20),),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: (){
                  Api.check_internet().then((value) {
                    if(value){
                      Get.back();
                    }
                  });
                },
                elevation: 2,

                color: Colors.white,
                child:Text(App_Localization.of(context).translate("reload"),style: App.textBlod(App.orange, 16),),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            ],
          ),
        ),
      ),
    );
  }

}