var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

var bookingList = [{"uuid":"1","confirmationNumber":78531998,"note":"Hawaii vacation","customer":{"emailAddress":"wasadm01@ford.com","firstName":"Unit","lastName":"Test","phone":"313-0000000"},"adventure":{"type":"Island","name":"Maui Survival","dailyPrice":165,"activities":["Helicopter Ride","Snorkeling","Surfing"]},"departingFlight":{"flightNumber":"NK211","price":389.7},"returningFlight":{"flightNumber":"NK701","price":289.7},"startDate":"Aug-12-2016","endDate":"Sep-11-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"2","confirmationNumber":11111111,"note":"Get a nice spa massage at the resort","customer":{"emailAddress":"wasadm01@ford.com","firstName":"Unit","lastName":"Test","phone":"313-0000000"},"adventure":{"type":"Mountain","name":"Mountain Relaxation","dailyPrice":155,"activities":["Hiking","Bird Watching","Spa Masssge"]},"departingFlight":{"flightNumber":"CA12","price":625.5},"returningFlight":{"flightNumber":"CA41","price":245.5},"startDate":"Aug-17-2016","endDate":"Sep-11-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"3","confirmationNumber":23232323,"note":"Try some mountain biking","customer":{"emailAddress":"wasadm01@ford.com","firstName":"Unit","lastName":"Test","phone":"313-0000000"},"adventure":{"type":"Mountain","name":"Mountain Climbing","dailyPrice":136,"activities":["Mountain Climbing","Mountain Biking","Hiking"]},"departingFlight":{"flightNumber":"NW11","price":134.35},"returningFlight":{"flightNumber":"NW123","price":234.35},"startDate":"Aug-07-2016","endDate":"Sep-06-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"5","confirmationNumber":56789012,"note":"Take a peek at Mars","customer":{"emailAddress":"wasadm01@ford.com","firstName":"Unit","lastName":"Test","phone":"313-0000000"},"adventure":{"type":"Orbital","name":"Orbital Appreciation","dailyPrice":255,"activities":["Space Walk","Space Experiments"]},"departingFlight":{"flightNumber":"UA102","price":708.5},"returningFlight":{"flightNumber":"UA514","price":208.5},"startDate":"Jul-23-2016","endDate":"Sep-11-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"6","confirmationNumber":32154398,"note":"Booking for Test Customer","customer":{"emailAddress":"test1Cust@ford.com","firstName":"Customer","lastName":"Test"},"adventure":{"type":"Orbital","name":"Orbital Appreciation","dailyPrice":255,"activities":["Space Walk","Space Experiments"]},"departingFlight":{"flightNumber":"UA102","price":708.5},"returningFlight":{"flightNumber":"UA514","price":208.5},"startDate":"Sep-11-2016","endDate":"Sep-26-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"8","confirmationNumber":11223344,"note":"Booking for Test Customer","customer":{"emailAddress":"test1Cust@ford.com","firstName":"Customer","lastName":"Test"},"adventure":{"type":"South Pole","name":"South Pole Relaxation","dailyPrice":185,"activities":["Barbeque","Fishing"]},"departingFlight":{"flightNumber":"UA102","price":908.5},"returningFlight":{"flightNumber":"UA514","price":308.5},"startDate":"Aug-22-2016","endDate":"Sep-11-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"9","confirmationNumber":99665533,"note":"Booking for Test Customer","customer":{"emailAddress":"test1Cust@ford.com","firstName":"Customer","lastName":"Test"},"adventure":{"type":"South Pole","name":"South Pole Survival","dailyPrice":195,"activities":["Boat Ride","Helicopter Ride","Hiking"]},"departingFlight":{"flightNumber":"SA136","price":508.5},"returningFlight":{"flightNumber":"SA34","price":208.5},"startDate":"Aug-12-2016","endDate":"Aug-22-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"10","confirmationNumber":54546767,"note":"Booking for Test Customer","customer":{"emailAddress":"test1Cust@ford.com","firstName":"Customer","lastName":"Test"},"adventure":{"type":"Mountain","name":"Mountain Climbing","dailyPrice":136,"activities":["Mountain Climbing","Mountain Biking","Hiking"]},"departingFlight":{"flightNumber":"NW11","price":508.5},"returningFlight":{"flightNumber":"NW123","price":208.5},"startDate":"Aug-12-2016","endDate":"Aug-22-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"11","confirmationNumber":98765432,"note":"Booking for Test Customer","customer":{"emailAddress":"test1Cust@ford.com","firstName":"Customer","lastName":"Test"},"adventure":{"type":"Mountain","name":"Mountain Climbing","dailyPrice":136,"activities":["Mountain Climbing","Mountain Biking","Hiking"]},"departingFlight":{"flightNumber":"UA102","price":508.5},"returningFlight":{"flightNumber":"UA514","price":208.5},"startDate":"Aug-12-2016","endDate":"Aug-22-2016","updateTime":"2016-07-13 13:53:38.609"},{"uuid":"7","confirmationNumber":10923488,"note":"Booking for Test Customer","customer":{"emailAddress":"test1Cust@ford.com","firstName":"Customer","lastName":"Test"},"adventure":{"type":"Western","name":"Dude Ranch","dailyPrice":125,"activities":["Bull Ride"]},"departingFlight":{"flightNumber":"UA102","price":708.5},"returningFlight":{"flightNumber":"UA514","price":208.5},"startDate":"Aug-11-2016","endDate":"Aug-27-2016","updateTime":"2016-07-13 14:29:38.105"}];
var adventureList = [{"type":"Jungle","name":"Amazon Appreciation","description":"Practice your appreciation skills in a jungle paradise.","location":"Amazon Jungle","dailyPrice":175,"activities":["Boat Ride","Hiking","Bird Watching"]},{"type":"Jungle","name":"Amazon Survival","description":"Explore the amazon rainforest.","location":"Amazon Jungle","dailyPrice":165,"activities":["Hiking","Rafting","Crocodile Wrestling"]},{"type":"Island","name":"Bahamas Relaxation","description":"Relax, unwind and enjoy in an island paradise.","location":"The Islands of the Bahamas","dailyPrice":125,"activities":["Fishing","Snorkeling","Spa Masssge"]},{"type":"Island","name":"Maui Survival","description":"Practice your survival skills in an island paradise.","location":"The Island of Maui","dailyPrice":165,"activities":["Helicopter Ride","Snorkeling","Surfing"]},{"type":"Island","name":"Tahiti Snorkeling","description":"Practice your snorkeling skills in an island paradise.","location":"The Islands of Tahiti","dailyPrice":175,"activities":["Fishing","Para Sailing","Snorkeling"]},{"type":"Western","name":"Dude Ranch","description":"Practice your cowboy skills in a western paradise.","location":"Texas","dailyPrice":125,"activities":["Bull Ride"]},{"type":"Western","name":"Urban Cowboy","description":"Practice your cowboy skills in the wild wild west.","location":"Texas","dailyPrice":118,"activities":["Barbeque"]},{"type":"Mountain","name":"Mountain Climbing","description":"Practice your climing skills in an elevated paradise.","location":"Mt.Kilimanjaro","dailyPrice":136,"activities":["Mountain Climbing","Mountain Biking","Hiking"]},{"type":"Mountain","name":"Mountain Relaxation","description":"Practice your relaxation skills in a elevated paradise.","location":"Mt.Kilimanjaro","dailyPrice":155,"activities":["Hiking","Bird Watching","Spa Masssge"]},{"type":"Orbital","name":"Orbital Appreciation","description":"See the earth from a new perspective.","location":"Space","dailyPrice":255,"activities":["Space Walk","Space Experiments"]},{"type":"South Pole","name":"South Pole Relaxation","description":"Practice your relaxation skills in a frozen paradise.","location":"Antarctica","dailyPrice":185,"activities":["Barbeque","Fishing"]},{"type":"South Pole","name":"South Pole Survival","description":"Practice your survival skills in a frozen paradise.","location":"Antarctica","dailyPrice":195,"activities":["Boat Ride","Helicopter Ride","Hiking"]}];
var maxFlightPriceList = ["200","400","600","800"];
var departingFlightList = [{"flightNumber":"CA12","airline":"Continental Airlines","arrivalTime":"17:30","departureTime":"15:30","price":625.5},{"flightNumber":"CA41","airline":"Continental Airlines","arrivalTime":"23:30","departureTime":"15:30","price":245.5},{"flightNumber":"CA416","airline":"Continental Airlines","arrivalTime":"23:30","departureTime":"19:30","price":121.35},{"flightNumber":"CA541","airline":"Continental Airlines","arrivalTime":"14:30","departureTime":"10:30","price":545.5},{"flightNumber":"CA98","airline":"Continental Airlines","arrivalTime":"11:30","departureTime":"08:30","price":345.5},{"flightNumber":"NK211","airline":"Spirit Airlines","arrivalTime":"18:30","departureTime":"14:30","price":389.7},{"flightNumber":"NK24","airline":"Spirit Airlines","arrivalTime":"17:30","departureTime":"14:30","price":589.7},{"flightNumber":"NK701","airline":"Spirit Airlines","arrivalTime":"16:30","departureTime":"13:30","price":289.7},{"flightNumber":"NK915","airline":"Spirit Airlines","arrivalTime":"21:30","departureTime":"17:30","price":189.7},{"flightNumber":"NK987","airline":"Spirit Airlines","arrivalTime":"13:30","departureTime":"10:30","price":189.7},{"flightNumber":"NW11","airline":"Northwest Airlines","arrivalTime":"15:30","departureTime":"09:30","price":134.35},{"flightNumber":"NW123","airline":"Northwest Airlines","arrivalTime":"10:30","departureTime":"05:30","price":234.35},{"flightNumber":"NW34","airline":"Northwest Airlines","arrivalTime":"22:30","departureTime":"04:30","price":284.35},{"flightNumber":"NW345","airline":"Northwest Airlines","arrivalTime":"22:30","departureTime":"13:30","price":114.35},{"flightNumber":"NW634","airline":"Northwest Airlines","arrivalTime":"20:30","departureTime":"16:30","price":684.35},{"flightNumber":"SA136","airline":"Southwest Airlines","arrivalTime":"20:40","departureTime":"13:45","price":319.45},{"flightNumber":"SA236","airline":"Southwest Airlines","arrivalTime":"10:40","departureTime":"06:45","price":219.45},{"flightNumber":"SA34","airline":"Southwest Airlines","arrivalTime":"10:40","departureTime":"06:45","price":189.45},{"flightNumber":"SA536","airline":"Southwest Airlines","arrivalTime":"17:40","departureTime":"13:45","price":719.45},{"flightNumber":"SA936","airline":"Southwest Airlines","arrivalTime":"23:40","departureTime":"13:45","price":109.45},{"flightNumber":"UA02","airline":"United Airlines","arrivalTime":"19:30","departureTime":"14:45","price":308.5},{"flightNumber":"UA09","airline":"United Airlines","arrivalTime":"11:30","departureTime":"06:30","price":598.5},{"flightNumber":"UA102","airline":"United Airlines","arrivalTime":"16:30","departureTime":"13:45","price":708.5},{"flightNumber":"UA192","airline":"United Airlines","arrivalTime":"11:30","departureTime":"06:30","price":398.5},{"flightNumber":"UA514","airline":"United Airlines","arrivalTime":"19:30","departureTime":"14:45","price":208.5}];
var returningFlightList = [{"flightNumber":"CA12","airline":"Continental Airlines","arrivalTime":"17:30","departureTime":"15:30","price":625.5},{"flightNumber":"CA41","airline":"Continental Airlines","arrivalTime":"23:30","departureTime":"15:30","price":245.5},{"flightNumber":"CA416","airline":"Continental Airlines","arrivalTime":"23:30","departureTime":"19:30","price":121.35},{"flightNumber":"CA541","airline":"Continental Airlines","arrivalTime":"14:30","departureTime":"10:30","price":545.5},{"flightNumber":"CA98","airline":"Continental Airlines","arrivalTime":"11:30","departureTime":"08:30","price":345.5},{"flightNumber":"NK211","airline":"Spirit Airlines","arrivalTime":"18:30","departureTime":"14:30","price":389.7},{"flightNumber":"NK24","airline":"Spirit Airlines","arrivalTime":"17:30","departureTime":"14:30","price":589.7},{"flightNumber":"NK701","airline":"Spirit Airlines","arrivalTime":"16:30","departureTime":"13:30","price":289.7},{"flightNumber":"NK915","airline":"Spirit Airlines","arrivalTime":"21:30","departureTime":"17:30","price":189.7},{"flightNumber":"NK987","airline":"Spirit Airlines","arrivalTime":"13:30","departureTime":"10:30","price":189.7},{"flightNumber":"NW11","airline":"Northwest Airlines","arrivalTime":"15:30","departureTime":"09:30","price":134.35},{"flightNumber":"NW123","airline":"Northwest Airlines","arrivalTime":"10:30","departureTime":"05:30","price":234.35},{"flightNumber":"NW34","airline":"Northwest Airlines","arrivalTime":"22:30","departureTime":"04:30","price":284.35},{"flightNumber":"NW345","airline":"Northwest Airlines","arrivalTime":"22:30","departureTime":"13:30","price":114.35},{"flightNumber":"NW634","airline":"Northwest Airlines","arrivalTime":"20:30","departureTime":"16:30","price":684.35},{"flightNumber":"SA136","airline":"Southwest Airlines","arrivalTime":"20:40","departureTime":"13:45","price":319.45},{"flightNumber":"SA236","airline":"Southwest Airlines","arrivalTime":"10:40","departureTime":"06:45","price":219.45},{"flightNumber":"SA34","airline":"Southwest Airlines","arrivalTime":"10:40","departureTime":"06:45","price":189.45},{"flightNumber":"SA536","airline":"Southwest Airlines","arrivalTime":"17:40","departureTime":"13:45","price":719.45},{"flightNumber":"SA936","airline":"Southwest Airlines","arrivalTime":"23:40","departureTime":"13:45","price":109.45},{"flightNumber":"UA02","airline":"United Airlines","arrivalTime":"19:30","departureTime":"14:45","price":308.5},{"flightNumber":"UA09","airline":"United Airlines","arrivalTime":"11:30","departureTime":"06:30","price":598.5},{"flightNumber":"UA102","airline":"United Airlines","arrivalTime":"16:30","departureTime":"13:45","price":708.5},{"flightNumber":"UA192","airline":"United Airlines","arrivalTime":"11:30","departureTime":"06:30","price":398.5},{"flightNumber":"UA514","airline":"United Airlines","arrivalTime":"19:30","departureTime":"14:45","price":208.5}];

app.get('/', function(req, res) {
	res.send('you found the root of the node server.');
});

app.get('/api/bookings', function(req, res){
	res.send(bookingList);
});

app.post('/api/bookings', function(req, res) {
	bookingList.push(req.body);
	bookingList[bookingList.length-1].confirmationNumber = bookingList.length-1;
	bookingList[bookingList.length-1].uuid = bookingList.length-1;
	
	var dateFormat = require('dateformat');
	var now = new Date();
	bookingList[bookingList.length-1].updateTime = dateFormat(now, "yyyy-MM-dd HH:mm:ss.SSS");
	res.sendStatus(bookingList.length-1);

	console.log(bookingList);
});

app.get('/api/adventures', function(req, res){
	res.send(adventureList);
});

app.get('/api/flightpriceoptions/maxflightprice', function(req, res){
	res.send(maxFlightPriceList);
});

app.get('/api/flights/departing', function(req, res){
	res.send(departingFlightList);
});

app.get('/api/flights/returning', function(req, res){
	res.send(returningFlightList);
});

app.listen(9500, function() {
	console.log('server listening on 9500.');
});