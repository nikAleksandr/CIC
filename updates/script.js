angular.module('CEUpdateForm', [])
.controller('FormController', ['$scope', function($scope) {
  //for debugging access to scope in the console
  window.MyScope = $scope;
  $scope.emptyJSON = {};
  $scope.master = {
    newDatasets:[]
  };
  $scope.datasets = [];
  $scope.indicators = [];

  $scope.addIndicator = function(indicator){
    //reformat thresholds from object to a simple array
    if(indicator.hasOwnProperty('thresholds')){
      var tempThresholds = indicator.thresholds;
      indicator.thresholds = [];
      for(i=0; i<4; i++){
        indicator.thresholds.push(tempThresholds[i]);
      }
    }

    $scope.indicators.push(indicator);
    $scope.dataset.children = $scope.indicators;

    $scope.resetVisibleForm();
    //clear only the indicator section of the form
    $scope.indicator = angular.copy($scope.emptyJSON);
  };

  $scope.addDataset = function(dataset, indicator) {
    $scope.addIndicator(indicator);

    var newDataset = dataset;
    newDataset.children = $scope.indicators;
    //reformat year into an array
    var tempYears = [ newDataset.years[0].value ];
    newDataset.years = tempYears;
    //reformat the companions property appropriately
    if(newDataset.hasOwnProperty('companions')){
      var numCompanions = Object.keys(newDataset.companions).length
      var tempCompanions = newDataset.companions;
      newDataset.companions = [];
      for(i=0; i<numCompanions; i++){
        newDataset.companions.push([newDataset.name, tempCompanions[i]]);
      }
    }
    
    $scope.master.newDatasets.push(newDataset);
    
    $scope.resetVisibleForm();
    //reset objects
    $scope.children = [];
    $scope.init();
  };

  $scope.additionalIndicator = function() {
    $scope.indicator = {};
  };

  $scope.init = function() {
    //initialize the angular working objects
    $scope.indicator = angular.copy($scope.emptyJSON);
    $scope.dataset = angular.copy($scope.emptyJSON);
  };

  $scope.resetVisibleForm = function(){
    //reset the form fields
    var frm_elements = document.getElementById('CEForm').elements;
    //starts at 1 so it doesn't clear the first form input, which holds the master info
    for (i = 2; i < frm_elements.length; i++){
        field_type = frm_elements[i].type.toLowerCase();
        switch (field_type){
          case "text":
          case "password":
          case "textarea":
          case "hidden":
            frm_elements[i].value = "";
            break;
          case "radio":
          case "checkbox":
            if (frm_elements[i].checked)
            {
              frm_elements[i].checked = false;
            }
            break;
          case "select-one":
          case "select-multi":
            frm_elements[i].selectedIndex = -1;
            break;
          default:
            break;
        }
    }
  };

  $scope.formSubmit = function(){
    $http({
    method  : 'POST',
    url     : 'process.php',
    data    : $.param($scope.formData),  // pass in data as strings
    headers : { 'Content-Type': 'application/x-www-form-urlencoded' }  // set the headers so angular passing info as form data (not request payload)
   })
    .success(function(data) {
      console.log(data);

      if (!data.success) {
        // if not successful, bind errors to error variables
        $scope.errorName = data.errors.name;
        $scope.errorSuperhero = data.errors.superheroAlias;
      } else {
        // if successful, bind success message to message
        $scope.message = data.message;
      }
    });
  };

  $scope.init();

}]);