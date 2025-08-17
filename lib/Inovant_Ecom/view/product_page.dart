import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controller/product_provider.dart';

class ProductPageDetails extends StatefulWidget {
  @override
  _ProductPageDetailsState createState() => _ProductPageDetailsState();
}

class _ProductPageDetailsState extends State<ProductPageDetails> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProductDetails();
  }


  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double imageWidth = screenWidth * 1.0;
    final double imageHeight = screenHeight * 0.45;
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final product = provider.product;
        if (product == null) {
          return Scaffold(
            backgroundColor: Colors.white,

            body: const Center(
              child: CircularProgressIndicator(color:Colors.blue),
            ),
          );
        }
       return  Scaffold(
         backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(product.name.toString(),style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              actions: [
                Icon(
                  Icons.favorite_outline_rounded,
                  color: Colors.black,
                  size: 22,
                ),
                SizedBox(width: 3,),
                Icon(
                  Icons.ios_share_outlined,
                  color: Colors.black,
                  size: 22,
                ),
                SizedBox(width: 3,),
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                  size: 22,
                ),
                SizedBox(width: 10,),
              ],
            ),

            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: imageHeight,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                        currentIndex = index;
                        });
                      },
                    ),

                    items: product.imageUrls.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          if (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
                            return Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: imageWidth,
                              height: imageHeight,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                    color: Colors.blue,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(child: Text('Failed to load image'));
                              },
                            );
                          } else {
                            return Center(child: Text('Invalid Image URL'));
                          }


                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: currentIndex,
                      count: product.imageUrls.length,
                      effect: ExpandingDotsEffect(
                        expansionFactor: 1.1,
                        dotColor: Colors.amber.shade100,
                        radius: 18,
                        strokeWidth: 2,
                        dotHeight: 12,
                        dotWidth: 12,
                        activeDotColor: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.brand_name.toUpperCase(), style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.5),),
                        // SizedBox(height: 8),
                        Text(
                          '\$${product.price}  KWD',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(product.name, style: GoogleFonts.poppins(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text('SKU: ${product.sku}', style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 13.5),),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom:7),
                    child: Text('Color:', style: GoogleFonts.poppins(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.5),),
                  ),
                 // Text('Colors: ${product.colors.join(', ')}', style: TextStyle(fontSize: 20)),
                 // SizedBox(height: 20),
                  Padding(
           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
           child: Container(
             height: 55,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: product.imageUrls.length,
               itemBuilder: (context, index) {
                 final imageUrl = product.imageUrls[index];
                 final isSelected = provider.selectedColor == product.colors[index]; // Assuming a selectedColor logic exists

                 return GestureDetector(
                   onTap: () {
                     provider.selectColor(product.colors[index]); // Assuming a selectColor method exists
                   },
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                     child: CircleAvatar(
                       backgroundColor: isSelected ? Colors.black87 : Colors.grey[300],
                       child: CircleAvatar(
                         backgroundColor: Colors.white,
                         radius: 25, // Adjust the size of the inner circle avatar
                         backgroundImage: NetworkImage(imageUrl),
                       ),
                       radius: 29, // Adjust the size of the outer circle avatar
                     ),
                   ),
                 );
               },
             ),
           ),
         ),

                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text('Quantity', style: GoogleFonts.poppins(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.5),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0,top: 5),
                    child: Row(
                      children: [
                        Container(
                          height:40,width: 42,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.indigo.shade100,
                            //     blurRadius: 2,
                            //     spreadRadius: 1,
                            //     offset: Offset(0, 1),
                            //   ),
                            // ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove,color: Colors.white,size: 15,),
                            onPressed: () {
                              if (product.quantity > 1) {
                                provider.setQuantity(provider.quantity - 1);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          height:40,width: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300)
                          ),
                          child: Center(
                            child: Text(provider.quantity.toString(),
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.5),),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          height:40,width: 42,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white,size: 16,),
                            onPressed: () {
                              provider.setQuantity(provider.quantity + 1);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      // backgroundColor: Colors.greenAccent,
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10)),
                      title: Text(
                        "Product Infromation".toUpperCase(),
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.5),
                      ),

                      textColor: Colors.black,
                      collapsedTextColor: Colors.black,
                      iconColor: Colors.black.withOpacity(.5),
                      collapsedIconColor: Colors.black.withOpacity(.5),
                      childrenPadding: const EdgeInsets.only(left: 15, bottom: 0, right: 15),

                      children: [
                        Text(
                          product.description.replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('</li>', '').replaceAll('<li>', '').replaceAll('<ul>', '').replaceAll('</ul>', '').replaceAll('<ol>', '').replaceAll('</ol>', ''),
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // if (productProvider.selectedColor != null)
                  //   Text(
                  //     'Selected Color: ${productProvider.selectedColor}',
                  //     style: GoogleFonts.poppins(
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 15.5),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                    child: Container(
                      height:50,
                      // width: 55,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Center(
                        child: Text('Add to bag',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: Container(
                      height:50,
                      // width: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade700)
                      ),
                      child: Center(
                        child: Text('Share',
                          style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),),
                      ),
                    ),
                  ),

                ],
              ),
            )
       );
      },
    );


  }
}

