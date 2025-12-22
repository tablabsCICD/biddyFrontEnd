

import 'dart:io';
import 'dart:math';

import 'package:biddy_customer/constant/api_constant.dart';
import 'package:biddy_customer/model/calculatedFareResponse.dart';
import 'package:biddy_customer/model/category_with_fare.dart';
import 'package:biddy_customer/provider/book_ride_provider.dart';
import 'package:biddy_customer/util/location.dart';
import 'package:biddy_customer/util/textview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import '../../constant/app_constant.dart';
import '../../constant/text_constant.dart';
import 'package:biddy_customer/util/colors.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../model/ride_pass_object.dart';
import '../../model/userdata.dart';
import '../../route/app_routes.dart';
import '../../util/sharepreferences.dart';
import '../../widgets/button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  UserData userData = UserData();
  int? userId;
  late BookRideProvider bookRideProvider;
  GoogleMapController? googleMapController;

  final TextEditingController pickUpController = TextEditingController();
  final TextEditingController dropController = TextEditingController();

  String dropLat = "";
  String dropLong = "";
  Set<Marker> markers = {};

  VericleFareResponse selectedCategoryWithFare = VericleFareResponse();
  late Position currentPos;
  String? currentAddress;

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    loadUserData();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookRideProvider("Ideal"),
      builder: (context, child) => buildPage(context),
    );
  }
  bool showAvailableRides = false;

  Widget buildPage(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        if (showAvailableRides) {
          // 👈 intercept back press, go back to cardView
          setState(() => showAvailableRides = false);
          return false;
        }
        // Show confirmation dialog
        bool? exitApp = await showDialog(
          context: context,
          barrierDismissible: false, // prevent tap outside to dismiss
          builder: (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to close the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // stay in app
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // exit app
                child: const Text("Exit"),
              ),
            ],
          ),
        );

        if (exitApp == true) {
          // Close app
          exit(0); // 👈 Forcibly closes app (works on Android, not recommended for iOS)
        }
        return Future.value(false); // prevent default back navigation
      },
      child: Scaffold(
        body: Consumer<BookRideProvider>(
          builder: (context, provider, child) {
            bookRideProvider = provider;
            return SafeArea(
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey,
                    height: MediaQuery.of(context).size.height,
                    child: buildGoogleMap(),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 5),
                      child: IconButton(
                        icon: Icon(Icons.menu, color: Colors.black, size: 30),
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.menu),
                      ),
                    ),
                  ),
                  showAvailableRides
                      ? availableRideCardView()
                      : cardView(provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------ UI COMPONENTS ------------------

  Widget rideCarType(VericleFareResponse category, int index) {
    int fareAmt = category.amount?.round() ?? 0;

    return Container(
      color: category.isSelect == true ? Colors.green[200] : Colors.white,
      child: ListTile(
        leading: Image.asset("assets/car.jpg",
            height: 98, width: 90, fit: BoxFit.fill),
        title: TextView(
          title: category.vehicleType ?? "",
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        subtitle: TextView(
          title: "4+1 Person",
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
        trailing: TextView(
          title: "\$ $fareAmt",
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget cardView(BookRideProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitleText(),
              SizedBox(height: 20),
              buildPickupField(),
              buildDestinationField(provider),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: AppButton(
                    buttonTitle: "Search Rides",
                    onClick: () async {
                      if (pickUpController.text.isNotEmpty &&
                          dropController.text.isNotEmpty) {
                        await provider.getFarePriceWithCategory(
                          AppConstant.currentLatLng.latitude,
                          AppConstant.currentLatLng.longitude,
                          double.parse(dropLat),
                          double.parse(dropLong),
                        );
                        setState(() => showAvailableRides = true); // 👈 show next view
                      }
                    },
                    enbale: true),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget availableRideCardView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 400,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){ setState(() => showAvailableRides = false); }, icon: Icon(Icons.arrow_back_ios)),
                  TextView(
                    title: "Available Rides",
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 15),
              buildRideList(),
              SizedBox(height: 15),
              buildBookRideButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitleText() {
    return TextView(
      title: "Where are you going today?",
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
  }

  bool isPickupLoading = false;
  bool isDropLoading = false;

  Widget buildPickupField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Stack(
            children: [
              GooglePlaceAutoCompleteTextField(
                textEditingController: pickUpController,
                googleAPIKey: APIConstants.GOOGLEAPIKEY,
                debounceTime: 800,
                countries: ['in', 'fr'],
                isLatLngRequired: true,
                inputDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.my_location, color: Colors.blue, size: 28),
                  fillColor: ThemeColor.textfeildBackground,
                  filled: true,
                  hintText: "Choose pick up point",
                  hintStyle: TextStyle(
                    color: Color(0x882C363F),
                    fontSize: 15,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                getPlaceDetailWithLatLng: (prediction) async {
                  setState(() => isPickupLoading = true);
                  AppConstant.currentLatLng = LatLng(
                    double.parse(prediction.lat!),
                    double.parse(prediction.lng!),
                  );
                  markers.clear();
                  markers.add(Marker(
                    markerId: MarkerId("pickupLocation"),
                    position: AppConstant.currentLatLng,
                  ));
                  googleMapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: AppConstant.currentLatLng,
                        zoom: 14,
                      ),
                    ),
                  );
                  bookRideProvider.setPickup(pickUpController.text);
                  setState(() => isPickupLoading = false);
                },
                itemClick: (prediction) {
                  pickUpController.text = prediction.description ?? "";
                  pickUpController.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0),
                  );
                  bookRideProvider.setPickup(pickUpController.text);
                },
              ),
              if (isPickupLoading)
                Positioned(
                  right: 10,
                  top: 16,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDestinationField(BookRideProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Stack(
            children: [
              GooglePlaceAutoCompleteTextField(
                textEditingController: dropController,
                googleAPIKey: APIConstants.GOOGLEAPIKEY,
                debounceTime: 800,
                countries: ['in', 'fr'],
                isLatLngRequired: true,
                inputDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined, color: Colors.deepOrange, size: 28),
                  fillColor: ThemeColor.textfeildBackground,
                  filled: true,
                  hintText: "Choose your destination",
                  hintStyle: TextStyle(
                    color: Color(0x882C363F),
                    fontSize: 15,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                getPlaceDetailWithLatLng: (prediction) async {
                  setState(() => isDropLoading = true);
                  dropLat = prediction.lat.toString();
                  dropLong = prediction.lng.toString();
                  createRouteIfAvailable();
                  await provider.getFarePriceWithCategory(
                    AppConstant.currentLatLng.latitude,
                    AppConstant.currentLatLng.longitude,
                    double.parse(dropLat),
                    double.parse(dropLong),
                  );
                  setState(() => isDropLoading = false);
                },
                itemClick: (prediction) {
                  dropController.text = prediction.description ?? "";
                  dropController.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description?.length ?? 0),
                  );
                  bookRideProvider.setDrop(dropController.text);
                },
              ),
              if (isDropLoading)
                Positioned(
                  right: 10,
                  top: 16,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRideList() {
    return SizedBox(
      height: 210,
      child: Consumer<BookRideProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.cabCategoryList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  for (var cab in provider.cabCategoryList) {
                    cab.isSelect = false;
                  }
                  provider.cabCategoryList[index].isSelect = true;
                  selectedCategoryWithFare = provider.cabCategoryList[index];
                  setState(() {});
                },
                child: rideCarType(provider.cabCategoryList[index], index),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildBookRideButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: userData.data == null
          ? Center(child: CircularProgressIndicator())
          : AppButton(
        buttonTitle: "Book Ride",
        enbale: true,
        onClick: () async {
          if (true) {
            getLatLngFromAddress(bookRideProvider.drop.toString());
            var rideFare = await bookRideProvider.getFarePrice(
              AppConstant.currentLatLng.latitude.toString(),
              AppConstant.currentLatLng.longitude.toString(),
              dropLat,
              dropLong,
              1,
            );

            var categoryFareResponse =
            CalculatedFareResponse.fromJson(rideFare.response);
            String farePrice = categoryFareResponse
                .data?.vericleFareResponse?[0].amount
                ?.toString() ??
                "0";
            String maxDistance =
                categoryFareResponse.data?.distance.toString() ?? "0";

            LatLng pickUp = LatLng(
                AppConstant.currentLatLng.latitude,
                AppConstant.currentLatLng.longitude);
            LatLng dropUp =
            LatLng(double.parse(dropLat), double.parse(dropLong));

            RidePass ridePass = RidePass(
              farePrice,
              pickUp,
              dropUp,
              pickUpController.text,
              dropController.text,
              polylines,
              maxDistance,
              '20',
              selectedCategoryWithFare,
            );

            Navigator.pushNamed(
              context,
              AppRoutes.bookingride,
              arguments: ridePass,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                Text("Pickup or destination location is missing!"),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }

  // ------------------ MAP & LOCATION ------------------

  // Add these fields in your State class

  double? tripDistance; // distance in KM

// ------------------ GOOGLE MAP ------------------



  Widget buildGoogleMap() {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          mapType: MapType.normal,
          polylines: Set<Polyline>.of(polylines.values),
          initialCameraPosition: CameraPosition(
            target: AppConstant.currentLatLng,
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            googleMapController = controller;
          },
        ),

        // Distance Display
        if (tripDistance != null)
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Text(
                "Distance: ${tripDistance!.toStringAsFixed(2)} km",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }

// ------------------ ADDRESS & LOCATION ------------------

  Future<void> getLocation() async {
    currentPos = await CurrentLocation().getlocation();
    setState(() {});
    getAddressFromLatLng(currentPos);
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      currentAddress = "${place.street}, ${place.subLocality}";

      setState(() {
        pickUpController.text = currentAddress ?? "";
        bookRideProvider.setPickup(pickUpController.text);

        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14,
            ),
          ),
        );

        markers.clear();
        markers.add(Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
    return null;
  }

// ------------------ POLYLINE ------------------

  // Add this field
  double? totalDistanceKm;

  Future<void> _createPolylines(
      double startLat,
      double startLng,
      double destLat,
      double destLng,
      ) async {
    polylines.clear();
    polylineCoordinates.clear();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIConstants.GOOGLEAPIKEY,
      PointLatLng(startLat, startLng),
      PointLatLng(destLat, destLng),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Calculate distance in KM
      totalDistanceKm = 0;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistanceKm = totalDistanceKm! +
            _coordinateDistance(
              polylineCoordinates[i].latitude,
              polylineCoordinates[i].longitude,
              polylineCoordinates[i + 1].latitude,
              polylineCoordinates[i + 1].longitude,
            );
      }

      polylines[PolylineId('poly')] = Polyline(
        polylineId: const PolylineId('poly'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      );
    }

    // ✅ Update state
    setState(() {});

    // ✅ Move camera to fit route
    _fitCameraToPolyline();
  }

// Helper function to calculate distance between coordinates
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // Distance in KM
  }

// ✅ Move camera to fit both pickup & drop
  void _fitCameraToPolyline() {
    if (polylineCoordinates.isEmpty || googleMapController == null) return;

    LatLngBounds bounds;
    double minLat = polylineCoordinates.first.latitude;
    double maxLat = polylineCoordinates.first.latitude;
    double minLng = polylineCoordinates.first.longitude;
    double maxLng = polylineCoordinates.first.longitude;

    for (var point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    googleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }



// ------------------ ROUTE ------------------

  Future<void> createRouteIfAvailable() async {
    final pickup = pickUpController.text.trim();
    final drop = dropController.text.trim();

    if (pickup.isNotEmpty && drop.isNotEmpty) {
      final pickupLatLng = await getLatLngFromAddress(pickup);
      final dropLatLng = await getLatLngFromAddress(drop);

      if (pickupLatLng != null && dropLatLng != null) {
        markers.clear();

        markers.add(Marker(
          markerId: const MarkerId("pickup"),
          position: pickupLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));

        markers.add(Marker(
          markerId: const MarkerId("drop"),
          position: dropLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));

        await _createPolylines(
          pickupLatLng.latitude,
          pickupLatLng.longitude,
          dropLatLng.latitude,
          dropLatLng.longitude,
        );
      }
    } else {
      debugPrint("Pickup or Drop is empty → Polyline not created");
    }
  }


  void loadUserData() async {
    userData = await LocalSharePreferences().getLoginData();
    setState(() => userId = userData.data?.id);
  }

  Future<void> getCabCategories() async {
    var cabCategories = await bookRideProvider.getAllCategories();
    if (cabCategories.status == 200 && cabCategories.response["success"]) {
      debugPrint("Categories: ${cabCategories.response["data"]["content"]}");
    } else {
      debugPrint("Error fetching categories: ${cabCategories.response["message"]}");
    }
  }
}
