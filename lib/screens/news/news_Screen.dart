import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stroymarket/bloc/news/news_bloc.dart';
import 'package:stroymarket/bloc/news/news_state.dart';


import '../../export_files.dart';
import '../../manager/4_category_manager.dart';
import '../../manager/9_news_manager.dart';

// ignore: must_be_immutable
class NewsScreen extends StatefulWidget {
  NewsScreen({super.key});
  List<String> images = [
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/white-disposable-lighter-rXgg90zA820',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/white-disposable-lighter-rXgg90zA820',
    'https://source.unsplash.com/user/hocza/brown-wooden-hammer-D3nouOYbALc',
    'https://source.unsplash.com/user/hocza/three-silver-keys-y5N2HDwagVw',
  ];
  List<String> titles = [
    'Kalit',
    "Bolg'a",
    'Zajigalka',
    "Bolg'a",
    'Kalit',
    'Kalit',
    "Bolg'a",
    'Zajigalka',
    "Bolg'a",
    'Kalit',
  ];

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    NewsManager.getAll(context,);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey,
        'Yangiliklar',
        () {
          Navigator.of(context).pop();
        },
        'assets/icons/chevron-left.png',
      ),
      body:
      
      BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
            if (state is NewsSuccessState) {
               if(state.data.length ==0 ){
                return Center(child:  SizedBox(
                    width: 365.w,
                    child: Text(
                      "Yangilik mavjud emas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
               );
              }
              return NewsScreenBody(state.data ?? []);

              
            }else if(state is NewsWaitingState){
      return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color:  AppConstant.primaryColor,
                    strokeWidth: 6.w,
                    strokeAlign: 2,
                    strokeCap: StrokeCap.round,
                    backgroundColor:  AppConstant.primaryColor.withOpacity(0.2),
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  SizedBox(
                    width: 365.w,
                    child: Text(
                      "Ma\'lumot yuklanmoqda...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ));
         
            }
            
             else {
              return SizedBox();
            }
          }), 
    );
  }

  NewsScreenBody<Widget>(List data) {
    return SafeArea(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(bottom: 10.h),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                height: 200.h,
                width: MediaQuery.of(context).size.width,
                
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(6.r),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                       imageUrl: data[index]["image"] != null ?  Endpoints.domain +
                        data[index]["image"].toString() +
                        "?key=${Endpoints.authKey}"   :  AppConstant.defaultImage,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppConstant.greyColor.withOpacity(0.6),
                      highlightColor: Colors.white70,
                      child: Container(
                        color: AppConstant.greyColor,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      print(url);
                      print(error);
                     return const Icon(Icons.error);
                    }
                        
                  ),
                ),
              ),
              GestureDetector(
                // onTap: () {
                //   Navigator.of(context).pushNamed(
                //     '/productsScreen',
                //     arguments: {
                //       "data" :data[index]
                //     }
                //   );
                // },
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                  height: 200.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          data[index]["title"] ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          data[index]["subtitle"] ?? "",
                     softWrap: true,
                     overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                           SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
