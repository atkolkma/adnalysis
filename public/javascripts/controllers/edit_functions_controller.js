functionsEditor = angular.module('functionsEditor',['controllers'])


controllers = angular.module('controllers',[]);

controllers.controller("functionsEditorController", [ '$scope', '$http', '$timeout', '$filter', '$sce', '$templateCache', function($scope, $http, $timeout, $filter, $sce, $templateCache) {
	'use strict';
	$scope.functions = [];

	$scope.getForms = function() {
		var partials = [];
		$http({
			url: "get_forms",
			method: "GET"
		}).success(function(data, status) {
			partials = data;
		}).then(function() {
			for(var i in partials){
		        $templateCache.put(partials[i].name, partials[i].content);
		    }
		});

		
	}; 

	$scope.updateFunctions = function() {
		$http({
			url: "update_functions.json",
			data: {functions: $scope.functions},
			method: "PUT",
			headers: {'Content-Type': 'application/x-www-form-urlencoded'}
		}).success(function(data, status) {
			$scope.functions = data;
			console.log("success");
		});
	};

	$scope.deleteFunction = function(index) {
		$scope.functions.splice(index, 1);
	};

	$scope.updateEditing = function(updated) {
		$scope.functions[$scope.editingFunctionIndex] = updated;
	};

	$scope.functionNames = ['Truncate', 'Filter', 'Sort', 'Group'];

	$scope.commitFunction = function() {
		console.log($scope.functions);
		$scope.editingFunctionIndex = -1;
	};

	$scope.addFunction = function() {
		console.log($scope.functions)
		$scope.functions = $scope.functions.concat({});
		$scope.editingFunctionIndex = $scope.functions.length -1;
		$scope.editing = $scope.functions[$scope.editingFunctionIndex];
	};

	$scope.updateEditing = function() {
		$scope.functions[$scope.editingFunctionIndex] = $scope.editingFunction;
		console.log($scope.editingFunction);
		console.log($scope.functions);
	};

	$scope.isEditingFunction = function(index) {
		return $scope.editingFunctionIndex == index;
	};

	$scope.displayFunction = function() {
		$scope.functions = $scope.functions.concat({name: "new", args: []});
	};

	$scope.init = function() {
		$scope.getForms();

		$http({
			url: "functions",
			method: "GET"
		}).success(function(data, status) {
			$scope.functions = data;
		});
	};

	$scope.init();

}]);
