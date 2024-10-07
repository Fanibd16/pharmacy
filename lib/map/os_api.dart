

/// OPENROUTESERVICE DIRECTION SERVICE REQUEST 
/// Parameters are : startPoint, endPoint and api key

const String baseUrl = 'https://api.openrouteservice.org/v2/directions/driving-car';
const String apiKey = '5b3ce3597851110001cf6248f4269abc756d48fa8e630566f469d713';

getRouteUrl(String startPoint, String endPoint){
  return Uri.parse('$baseUrl?api_key=$apiKey&start=$startPoint&end=$endPoint');
}