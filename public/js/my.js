angular.module('my', ['ngRoute']).config(function($routeProvider) {
$routeProvider
	.when('/', {templateUrl:'partials/index.html'})
	.when('/all', {templateUrl:'partials/all.html',controller:'Ctrl1'})
	.when('/row/:name', {templateUrl:'partials/one.html',controller:'Ctrl2'})
	.otherwise({redirectTo: '/'});
})
.controller('Ctrl1', function($scope,$http) {
	$http.post("/all").then(function(response){
		$scope.all = response.data.all;
	});
})
.controller('Ctrl2', function($scope,$routeParams,$http) {
	$http.post("/row/"+$routeParams.name).then(function(response){
		$scope.id = response.data.id;
		$scope.name = response.data.name;
	});
});