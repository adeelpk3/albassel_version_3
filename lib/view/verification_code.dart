import 'package:albassel_version_1/app_localization.dart';
import 'package:albassel_version_1/const/app.dart';
import 'package:albassel_version_1/controler/sign_up_controller.dart';
import 'package:albassel_version_1/controler/verification_code_controller.dart';
import 'package:albassel_version_1/view/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationCode extends StatelessWidget{

  VerificationCodeController verificationCodeController= Get.put(VerificationCodeController());

  TextEditingController code=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx((){
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background/signin.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child:verificationCodeController.loading.value?
                Center(child: CircularProgressIndicator(),)
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,)
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Image.asset("assets/logo/logo.png"),
                    ),

                    Column(
                      children: [
                        textFieldBlock("v_code",code,context,verificationCodeController.code_vaildate.value),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                verificationCodeController.resend(context);
                              },
                              child: Text(App_Localization.of(context).translate("re_send"),style: TextStyle(color: App.midOrange,fontSize: 12),),
                            )
                          ],
                        )
                      ],
                    ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       GestureDetector(
                         onTap: (){
                           verificationCodeController.verificate(context, code.value.text);
                         },
                         child: Container(
                           width: MediaQuery.of(context).size.width*0.4,
                           height:  MediaQuery.of(context).size.height * 0.06 > 70
                               ? 70
                               : MediaQuery.of(context).size.height * 0.06,
                           decoration: BoxDecoration(
                               color: App.midOrange,
                               borderRadius: BorderRadius.circular(50)
                           ),
                           child: Center(
                             child: Text(App_Localization.of(context).translate("send").toUpperCase(),style: App.textBlod(Colors.white, 18),),
                           ),
                         ),
                       ),

                       GestureDetector(
                         onTap: (){
                           Get.offAll(()=>Home());
                         },
                         child: Container(
                           width: MediaQuery.of(context).size.width*0.4,
                           height:  MediaQuery.of(context).size.height * 0.06 > 70
                               ? 70
                               : MediaQuery.of(context).size.height * 0.06,
                           decoration: BoxDecoration(
                               color: App.midOrange,
                               borderRadius: BorderRadius.circular(50)
                           ),
                           child: Center(
                             child: Text(App_Localization.of(context).translate("cancel").toUpperCase(),style: App.textBlod(Colors.white, 18),),
                           ),
                         ),
                       ),
                     ],
                   )



                  ],
                ),
              ),
            ),
          );
        })
    );
  }

  textFieldBlock(String translate,TextEditingController controller,BuildContext context,bool validate){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(App_Localization.of(context).translate(translate),style: App.textNormal(Colors.grey, 14),),
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width*0.9,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: validate?Colors.white:Colors.red)
              ),
              focusedBorder:  UnderlineInputBorder(
                  borderSide: BorderSide(color: validate?App.orange:Colors.red)
              ),
            ),
            style: App.textNormal(Colors.white, 14),
          ),
        ),
        SizedBox(height: 50,)
      ],
    );
  }


}