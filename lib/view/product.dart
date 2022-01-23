import 'package:albassel_version_1/app_localization.dart';
import 'package:albassel_version_1/const/app.dart';
import 'package:albassel_version_1/const/global.dart';
import 'package:albassel_version_1/controler/cart_controller.dart';
import 'package:albassel_version_1/controler/home_controller.dart';
import 'package:albassel_version_1/controler/product_controller.dart';
import 'package:albassel_version_1/controler/wish_list_controller.dart';
import 'package:albassel_version_1/my_model/my_api.dart';
import 'package:albassel_version_1/my_model/my_product.dart';
import 'package:albassel_version_1/my_model/product_info.dart';
import 'package:albassel_version_1/view/no_internet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


class ProductView extends StatelessWidget {

  HomeController homeController=Get.find();
  WishListController wishListController = Get.find();
  CartController cartController = Get.find();
  ProductController productController=Get.put(ProductController());
  ProductInfo myProduct ;
  TextEditingController reviewController = TextEditingController();
  double product_rating=0;

  ProductView(this.myProduct){
    productController.myProduct=this.myProduct;
    for(int i=0;i<wishListController.rate.length;i++){
      if(myProduct.id==wishListController.rate[i].id){
        product_rating=wishListController.rate[i].rate;
      }
    }
    MyProduct myProduct1 = MyProduct(id: myProduct.id, subCategoryId: myProduct.subCategoryId, brandId: myProduct.brandId, title: myProduct.title, subTitle: myProduct.subTitle, description: myProduct.description, price: myProduct.price, rate: myProduct.rate, image: myProduct.image, ratingCount: myProduct.ratingCount,availability: myProduct.availability);
    wishListController.add_to_recently(myProduct1);
    productController.myProduct!.is_favoirite.value=wishListController.is_favorite(myProduct1);
  }

  go_to_product(int index){
    productController.loading.value=true;
    MyApi.check_internet().then((internet) {
      if (internet) {
        MyApi.getProductsInfo(wishListController.recently[index].id).then((value) {
          productController.loading.value=false;
          product_rating=0;
          for(int i=0;i<wishListController.rate.length;i++){
            if(value!.id==wishListController.rate[i].id){
              product_rating=wishListController.rate[i].rate;
            }
          }
          productController.myProduct=value;
          MyProduct myProduct1 = MyProduct(id: productController.myProduct!.id, subCategoryId: productController.myProduct!.subCategoryId, brandId: productController.myProduct!.brandId, title: productController.myProduct!.title, subTitle: productController.myProduct!.subTitle, description: productController.myProduct!.description, price: productController.myProduct!.price, rate: productController.myProduct!.rate, image: productController.myProduct!.image, ratingCount: productController.myProduct!.ratingCount,availability: productController.myProduct!.availability);
          productController.myProduct!.is_favoirite.value=wishListController.is_favorite(myProduct1);
        }).catchError((err){
          productController.loading.value=false;
        });
      }else{
        Get.to(()=>NoInternet())!.then((value) {
          go_to_product(index);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx((){
        return SafeArea(child: SingleChildScrollView(

          child: Container(
            width: MediaQuery.of(context).size.width,

            child: productController.loading.value?
            Container(color: Colors.white,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,child: Center(child: CircularProgressIndicator(),))
                :SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                  children: [
                    _slider(context),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                          _title(context),
                          SizedBox(height: 10,),
                          _price_avalibilty(context),
                          SizedBox(height: 10,),
                          _desc(context),
                          SizedBox(height: 10,),
                          _add_to_cart(context),
                          SizedBox(height: 10,),
                          _rate(context),
                          SizedBox(height: 10,),
                          _add_review(context),
                          SizedBox(height: 10,),
                          _review(context),
                          SizedBox(height: 10,),
                          _recently(context),
                          SizedBox(height: 10,),
                        ],
                      ),
                    )

                  ],
              ),
            ),
          ),
        ));
      }),
    );
  }

  _rate(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(App_Localization.of(context).translate("add_rate"),style: App.textBlod(Colors.black, 16),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: product_rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  // ignoreGestures: true,
                  itemSize: 35,
                  // allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: App.midOrange,
                  ),
                  onRatingUpdate: (rating) {
                    MyProduct myProduct1 = MyProduct(id: myProduct.id, subCategoryId: myProduct.subCategoryId, brandId: myProduct.brandId, title: myProduct.title, subTitle: myProduct.subTitle, description: myProduct.description, price: myProduct.price, rate: myProduct.rate, image: myProduct.image, ratingCount: myProduct.ratingCount,availability: myProduct.availability);
                    wishListController.add_to_rate(myProduct1, rating);
                    MyApi.rate(productController.myProduct!, rating);

                  },

                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _slider(BuildContext context){
    return Stack(
      children: [
        Container(height: MediaQuery.of(context).size.height * 0.4,),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
                boxShadow: [
                  App.box_shadow()
                ]
            ),
            /**slider*/
            child: CarouselSlider(
              items:
              productController.myProduct!.images.map((e) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
                      image: DecorationImage(
                          image: NetworkImage(
                              e.link),
                          fit: BoxFit.contain)),
                );
              }).toList(),

              options: CarouselOptions(
                autoPlay: productController.myProduct!.images.length>1?true:false,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 1.0,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  productController.selected_slider.value=index;
                },
              ),
            ),
          ),
        ),
        /**3 point*/
        Positioned(
          top: MediaQuery.of(context).size.height * 0.35,
          left: 20,
          right: 20,
          child: Container(
            width: MediaQuery.of(context).size.width-20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: productController.myProduct!.images.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: productController.selected_slider.value == productController.myProduct!.images.indexOf(e)
                          ? App.orange
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        /**header row*/
        Positioned(
          left: 10,
          top: 10,
          child: Container(
            width: MediaQuery.of(context).size.width-10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){
                  Get.back();
                }, icon: Icon(Icons.arrow_back_ios,color: App.orange,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  ],
                ),
                IconButton(onPressed: (){
                  productController.favorite(productController.myProduct!,context);
                }, icon: Icon(productController.myProduct!.is_favoirite.value?Icons.favorite:Icons.favorite_border,color: App.orange,))
              ],
            )
          ),
        )
      ],
    );
  }
  _title(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            child: Text(productController.myProduct!.title,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.clip,),textAlign: TextAlign.left,),
          ),
        ),
      ],
    );
  }
  _price_avalibilty(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(App_Localization.of(context).translate("aed")+" "+productController.myProduct!.price.toString(),style: TextStyle(color: App.orange,fontSize: 24,overflow: TextOverflow.clip,),textAlign: TextAlign.center,),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.star,color: App.orange,size: 28,),
                        SizedBox(width: 7,),
                        Text(productController.myProduct!.rate.toStringAsFixed(2),style: TextStyle(color: App.orange,fontSize: 24,overflow: TextOverflow.clip,),textAlign: TextAlign.center,),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(App_Localization.of(context).translate("availability")+": ",style: TextStyle(color: Colors.black,fontSize: 14,overflow: TextOverflow.clip,),textAlign: TextAlign.center,),
                    Text(productController.myProduct!.availability<0?"0":productController.myProduct!.availability.toString(),style: TextStyle(color: Colors.black,fontSize: 14,overflow: TextOverflow.clip,),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
  _desc(BuildContext context){
    return  Padding(
      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05),
      child: Column(
        children: [
          Row(
            children: [
              Text(App_Localization.of(context).translate("desc"),style: App.textBlod(Colors.black, 18),textAlign: TextAlign.left,)
            ],
          ),
          Html(data: productController.myProduct!.description),
        ],
      ),
    );
  }
  _add_to_cart(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05),
            child: GestureDetector(
              onTap: (){
                productController.add_to_cart();
                App.sucss_msg(context, App_Localization.of(context).translate("cart_msg"));
                showAlertDialog(context,productController.myProduct!);
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width*0.3,
                decoration: BoxDecoration(
                  color: App.midOrange,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text(App_Localization.of(context).translate("add_cart"),style: App.textNormal(Colors.white, 14),),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.05),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width*0.3,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      productController.increase();
                    }, icon: Icon(Icons.add,)),
                    Text(productController.cart_count.toString()),
                    IconButton(onPressed: (){
                      productController.decrease();
                    }, icon: Icon(Icons.remove,))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  _add_review(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.1,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(App_Localization.of(context).translate("review"),style: App.textBlod(Colors.black, 16),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.6,
                    child: App.textField(reviewController, "write_yours", context,validate:reviewController.text.isNotEmpty),
                ),

                GestureDetector(
                  onTap: (){
                    // print( productController.myProduct!.id.toString());
                    if(Global.customer!=null){
                      if(reviewController.text.isNotEmpty){
                        List<Review> reviews=<Review>[];
                        reviews.add(Review(customerName: Global.customer!.firstname,body: reviewController.text,customerId: Global.customer!.id,id: -1,priductId: productController.myProduct!.id));
                        reviews.addAll(productController.myProduct!.reviews);
                        productController.myProduct!.reviews=reviews;
                        productController.add_review(reviewController.text, productController.myProduct!.id, context);
                        reviewController.text="";
                      }
                    }else{
                      App.error_msg(context, App_Localization.of(context).translate("login_first"));
                    }

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.25,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Center(child: Text(App_Localization.of(context).translate("publish"),style: App.textNormal(App.midOrange, 14),)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _review(BuildContext context){
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
      child: Container(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            itemCount: productController.myProduct!.reviews.length,
            itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productController.myProduct!.reviews[index].customerName,style: App.textBlod(Colors.black, 16),),
                    Text(productController.myProduct!.reviews[index].body,style: TextStyle(fontSize: 12,color: Colors.grey),),
                  ],
                ),
            ),
          );
        }),
      ),
    );
  }

  _recently(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(App_Localization.of(context).translate("recently_view"),style: App.textBlod(Colors.black, 16)),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wishListController.recently.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  productController.selected_slider.value=0;
                 go_to_product(index);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.height*0.2,
                  child: Column(
                    children: [
                      Expanded(flex :3,
                          child: Container(decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(wishListController.recently[index].image)
                            )
                          ),),),
                      Expanded(flex:1,child: Container(child: Text(wishListController.recently[index].title,textAlign: TextAlign.center,style: App.textNormal(Colors.black, 10),maxLines: 2,)))
                    ],
                  ),
                ),
              );
            })
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context,ProductInfo product) {

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 18,child: Icon(Icons.check),backgroundColor: App.midOrange,),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: MediaQuery.of(context).size.width*0.5,child: Text(product.title,style: App.textBlod(Colors.black, 12),)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(App_Localization.of(context).translate("added_cart"),style: App.textNormal(Colors.grey, 12),),
                      ],
                    ),

                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text(App_Localization.of(context).translate("cart_total")+": ",style: App.textBlod(Colors.black, 10),),
                    Text(App_Localization.of(context).translate("aed")+" ",style: App.textNormal(Colors.black, 10),),
                    Text(productController.cartController.total.value,style: App.textNormal(Colors.black, 10),),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width*0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          border: Border.all(color:App.midOrange,width: 2)
                        ),
                        child: Center(
                          child: Text(App_Localization.of(context).translate("continue_shopping"),style: App.textNormal(App.midOrange, 8),),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                        homeController.selected_bottom_nav_bar.value=2;
                      },
                      child: Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width*0.25,
                        decoration: BoxDecoration(
                            color: App.midOrange,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                          child: Text(App_Localization.of(context).translate("checkout"),style: App.textNormal(Colors.white, 8),),
                        ),
                      ),
                    ),
                    ],
                ),

              ],
            )
          ],
        ),
      ),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}