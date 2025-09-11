import 'package:stroymarket/bloc/serviceAll/serviceAll_bloc.dart';
import 'package:stroymarket/bloc/serviceAll/serviceAll_state.dart';
import 'package:stroymarket/manager/10_services_manager.dart';


import '../../export_files.dart';

// ignore: must_be_immutable
class ServiceAllScreen extends StatefulWidget {
  ServiceAllScreen({super.key});
 

  @override
  State<ServiceAllScreen> createState() => _ServiceAllScreenState();
}

class _ServiceAllScreenState extends State<ServiceAllScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    ServicesManager.getAll(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey,
        'Xizmatlar',
        () {
          Navigator.of(context).pop();
        },
        'assets/icons/chevron-left.png',
      ),
      body:
      
      BlocBuilder<ServiceAllBloc, ServiceAllState>(
              builder: (context, state) {
            if (state is ServiceAllSuccessState) {
               if(state.data.length ==0 ){
                return Center(child:  SizedBox(
                    width: 365.w,
                    child: Text(
                      "Xizmat mavjud emas",
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
              return ServiceAllScreenBody(state.data ?? []);

              
            }else if(state is ServiceAllWaitingState){
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

  ServiceAllScreenBody<Widget>(List data) {
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
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/workersScreen',
                    arguments: {
                      "data" :data[index]
                    }
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                  height: 200.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                       data[index]["name"] ?? "",
                           softWrap: true,
                           overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                       data[index]["desc"] ?? "",
                           softWrap: true,
                           overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
