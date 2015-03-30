functionsEditor = angular.module('functionsEditor',['controllers']);

controllers = angular.module('controllers',[]);

controllers.controller("functionsEditorController", [ '$scope', '$http', '$timeout', '$filter', function($scope, $http, $timeout, $filter) {
	'use strict';
	$scope.functions = {};

	$scope.updateFunctions = function() {
		$http({
			url: "update_function_settings.json",
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

	$scope.functionNames = ['Henry', 'Suzanne', 'Brenda'];

	$scope.commitFunction = function() {
		$scope.editingFunctionIndex = -1;
	};

	$scope.addFunction = function() {
		$scope.functions = $scope.functions.concat({});
		$scope.editingFunctionIndex = $scope.functions.length -1;
		$scope.editing = $scope.functions[$scope.editingFunctionIndex];
	};

	$scope.updateEditing = function(name) {
		$scope.functions[$scope.editingFunctionIndex]['name'] = name;
		console.log($scope.functions);
	};

	$scope.isEditingFunction = function(index) {
		return $scope.editingFunctionIndex == index;
	};

	$scope.displayFunction = function() {
		$scope.functions = $scope.functions.concat({name: "new", args: []});
	};

	$scope.init = function() {
		$http({
			url: "function_settings",
			method: "GET"
		}).success(function(data, status) {
			$scope.functions = data;
		});
	};

	$scope.init();

}]);
