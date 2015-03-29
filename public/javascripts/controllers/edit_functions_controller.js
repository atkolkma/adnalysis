functionsEditor = angular.module('functionsEditor',['controllers']);

controllers = angular.module('controllers',[]);

controllers.controller("functionsEditorController", [ '$scope', '$http', '$timeout', '$filter', function($scope, $http, $timeout, $filter) {
	'use strict';
	$scope.functions = {}
	$scope.test_data = [{name: "sort", args: {dimension: "clicks", direction: "asc"}}, {name: "group", args: [{dimension: "clicks"}, {dimension: "imps"}]}];

	$scope.init = function() {
		$http({
			url: "/crunch_algorithms/35/function_settings",
			method: "GET",
		}).success(function(data, status) {
			$scope.functions = data;
			console.log($scope.functions);
		});
	};

	$scope.init();

}]);
