
class APIConstants {

      static String BASE_URL = "http://ec2-13-201-5-93.ap-south-1.compute.amazonaws.com:8080/biddy/";
 //static String BASE_URL = 'http://ec2-13-201-5-172.ap-south-1.compute.amazonaws.com:8080/biddy_customerold/';
 //static String BASE_URL = 'http://ec2-13-234-204-105.ap-south-1.compute.amazonaws.com:8080/biddy_customer3/';
      static String GOOGLEAPIKEY ='AIzaSyAm332fBuy8QoCC6ZFv7pizIqdmaT-jz30';

      static String LOGIN = BASE_URL + 'user/Login/mobileNumber';
      static String SENDOTP = BASE_URL +'api/customers/sendOtp/';
      static String VERIFYOTP =BASE_URL + 'api/customers/verifyOtpOnMobileNumber2';
      static String SIGNUP = BASE_URL +'user/unique/User/register';
      static String BOOKCABRIDE = BASE_URL +'api/rides/create';
      static String GETCABCATEGORUIES = BASE_URL +'api/CabCategories/getAll';
      static String CALCULATEDISTANCETIMEPRICE = BASE_URL +'api/fare/calculateDistanceTimePrice2?pickupLat=';
      static String GETFAREWITHCABCATEGORY = BASE_URL +'api/fare/calculateDistanceTimePrice2?pickupLat=';
      static String EDIT_PROFILR=BASE_URL+'api/customers/updateCustomer';
      static String GET_PRISE=BASE_URL+"api/fare/static/calculateDistanceTimePrice2?";
      static String GET_RIDE_BY_ID=BASE_URL+"api/rides/getBy/";
      static String STATUS_CHANGE(int id,String status)=> BASE_URL+'ride/get2/{id}?id=$id&requestStatus=${status}';
      static String BIDLIST=BASE_URL+"Bid2/getFairList/ByRideId2?rideId=";
      static String ACCEPT_RIDE_DRIVER = BASE_URL +'ride/acceptRideFromUser';
      static String GET_RIDE_BY_USER_ID = BASE_URL + "api/rides/getByCustomerId/";
      static String RIDE_STATUS_CHANGE = BASE_URL + "api/rides/changeStatus";
      static String CurrentRide(int userId)=> BASE_URL+'api/rides/getByCustomerIdRequestedStatusAndNotNullBidAmt/$userId';
      static String GET_BIDS_BY_RIDE_ID = BASE_URL + "api/bids/getBankDetailsByRideId/";
      static String GET_VEHICLE_BY_ID(int vehicleId)=> BASE_URL+'api/getVehicle/$vehicleId';
}