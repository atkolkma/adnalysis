functionsEditor = angular.module('functionsEditor',['controllers'])


controllers = angular.module('controllers',[]);

controllers.controller("functionsEditorController", [ '$scope', '$http', '$timeout', '$filter', '$sce', '$templateCache', function($scope, $http, $timeout, $filter, $sce, $templateCache) {
	'use strict';
	$scope.functions = {};

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
		    console.log($templateCache.get('Truncate'));
		});

		
	}; 

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

	$scope.functionNames = ['Truncate', 'Filter', 'Sort', 'Group'];
	$scope.dimensionNames = ['clicks', 'imps', 'conversions', 'cost'];
	$scope.directionOptions = ['Ascending', 'Descending'];

	$scope.commitFunction = function() {
		console.log($scope.functions);
		$scope.editingFunctionIndex = -1;
	};

	$scope.addFunction = function() {
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

	$scope.getForm = function(funcName) {
		$http({
			url: "get_form?func="+funcName,
			method: "GET"
		}).success(function(data, status) {
			$scope.functionSelectorHtml = data;
		});
	};

	$scope.init = function() {
		$scope.getForms();

		$http({
			url: "function_settings",
			method: "GET"
		}).success(function(data, status) {
			$scope.functions = data;
		});
	};

	$scope.init();

}]);
