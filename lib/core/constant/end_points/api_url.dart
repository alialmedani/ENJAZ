
// const baseUrl = 'https://api.ecommerce.jedar.demo.erpmawared.com/'; //
const baseUrl = 'https://task.jasim-erp.com/'; //base_url_live
// const baseUrl = 'https://api.ecommerce.demo.jedar-center.com/'; //base_url_demo
// var baseImageUrl = "${CacheHelper.setting?.baseImageUrl}/"; //base_Image_url

//

const getlistdrink = '${baseUrl}api/app/drink'; // GET
const String createdrink = '${baseUrl}api/app/drink'; // POST
// قبل: getbyId(int id) => ...
String getbyId(String id) => '${baseUrl}api/app/drink/$id';

//
// lib/core/constant/end_points/api_url.dart

// ...
// lib/core/constant/end_points/api_url.dart
const String createDrinkOrderUrl = '${baseUrl}api/app/order';
const String getOrdersUrl = '${baseUrl}api/app/order';
 const String createDrinkOrderLiteUrl = "$baseUrl/api/app/order";
/////auth_url////////////
const loginUrl = '${baseUrl}connect/token';
const registerUrl = '${baseUrl}api/app/mobile-ecommerce-user-info';



