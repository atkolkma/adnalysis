dimensionsEditor = angular.module('dimensionsEditor',['controllers'])


controllers = angular.module('controllers',[]);

controllers.controller("dimensionsEditorController", [ '$scope', '$http', '$timeout', '$filter', '$sce', '$templateCache', function($scope, $http, $timeout, $filter, $sce, $templateCache) {
	'use strict';
	
	$scope.dimensions = [];
	$scope.calculationNames = ['Arithmetic', 'Division'];

	$scope.getForms = function() {
		var partials = [];
		$http({
			url: "calculated_dimensions_forms",
			method: "GET"
		}).success(function(data, status) {
			partials = data;
		}).then(function() {
			for(var i in partials){
		        $templateCache.put(partials[i].name, partials[i].content);
		    }
		});

		
	}; 

	$scope.updateDimensions = function() {
		$http({
			url: "update_calculated_dimensions.json",
			data: {dimensions: $scope.dimensions},
			method: "PUT",
			headers: {'Content-Type': 'application/x-www-form-urlencoded'}
		}).success(function(data, status) {
			$scope.dimensions = data;
			console.log("success");
		});
	};

	$scope.deleteDimension = function(index) {
		$scope.dimensions.splice(index, 1);
	};

	$scope.updateEditing = function(updated) {
		$scope.dimensions[$scope.editingDimensionIndex] = updated;
	};


	$scope.commitDimension = function() {
		$scope.editingDimensionIndex = -1;
	};

	$scope.addDimension = function() {
		$scope.dimensions = $scope.dimensions.concat({});
		$scope.editingDimensionIndex = $scope.dimensions.length -1;
		$scope.editing = $scope.dimensions[$scope.editingDimensionIndex];
	};

	$scope.updateEditing = function() {
		$scope.dimensions[$scope.editingDimensionIndex] = $scope.editingDimension;
	};

	$scope.isEditingDimension = function(index) {
		return $scope.editingDimensionIndex == index;
	};

	$scope.displayDimension = function() {
		$scope.dimensions = $scope.dimensions.concat({name: "new", args: []});
	};

	$scope.init = function() {
		$scope.getForms();

		$http({
			url: "calculated_dimensions",
			method: "GET"
		}).success(function(data, status) {
			$scope.dimensions = data;
		});
	};

	$scope.init();

}]);
