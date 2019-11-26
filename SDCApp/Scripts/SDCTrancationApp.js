
var myApp = angular.module("SDCApp", ['ngRoute']);

myApp.constant('ApiUrl', 'My App');



myApp.config(function ($provide) {

    $provide.decorator('$exceptionHandler', function ($delegate) {

        return function (exception, cause) {
            console.log('in exception');
            console.log(exception);
            console.log(cause);
            //$delegate(exception, cause);         
           
        };
    });
});

myApp.config(['$httpProvider', function ($httpProvider) {
    $httpProvider.interceptors.push(function ($q) {
        return {
            'response': function (response) {
                //Will only be called for HTTP up to 300
                console.log(response);
                return response;
            },
            'responseError': function (rejection) {
                if (rejection.status === 409) {
                   
                    console.log(rejection);
                }
                
                return $q.reject(rejection);
            }
        };
    });
}]);


(function (app) {

    
    "use strict";

    app.controller("UserCtrl", function ($scope, $http, $window, $sce, $route, $location, ApiUrl) {
        $scope.user = {
            firstName: "",
            lastName:"",
            title: "",
            phone: "",
            userId: "",
            affiliation:""
        };

       

        $scope.apiurl = "";

        $http.get('config/server.json').
            then(function (data) {
                $scope.apiurl = data.data.apiurl;              
                $scope.baseUrl = data.data.baseUrl;
            });

        $scope.register = function ($event,user) {

            user.userId = localStorage.getItem("user");
            $http.post($scope.apiurl + "api/user", JSON.stringify(user))

                .then(function (response, status) {

                    if (response) {
                        alert(response.data.UserId + " registered");
                        window.location.href = "home.html?User=" + user.userId;
                    }

                }
                    , function (response) {                      
                      
                        console.log(response.status);
                        alert(response.data);
                      
                    });
              
           
            $event.stopPropagation();
            $event.preventDefault();
        };  //register
    });  //controller

    app.controller("SDCTransactionCtrl", function ($scope, $http, $window, $sce, $route, $location, ApiUrl) {

        $scope.orderByField = 'PackageID';
        $scope.reverseSort = false;

        //console.log('start');
        //$scope.refreshForms = 0;
         //sort fields
        /*
       
        //custom for ordering date
        $scope.orderByDateUploaded = function (item) {
            var parts = item.dateString.split('/');
            var date = new Date(parseInt(parts[2],
                parseInt(parts[1]),
                parseInt(parts[0])));

            return date;
        };

    */

        var editingManagerName;
        var editingManagerUrl1;
        var editingManagerUrl2;

        var editingReceiverName;
        var editingReceiverUrl;
        var editingReceiverCOR;

        $scope.selectedReceivers = {};
        $scope.editingManagers = {};
        $scope.editingReceivers = {};
        $scope.FilteredForms = {};
        $scope.fillerSelectedManager = localStorage.getItem("fillerSelectedManager");
        $scope.fillerSelectedFormat = '';        
        $scope.formats = [{ id: '1', name: "XML" }
            ,{ id: '2', name: "HTML" }, { id: '3', name: "URL" }]; 
        $scope.result = '';

        $scope.wait = false;

        $scope.packageObjects = [{ index: 0, packageid: '', format: '', selected: false }];      
        $scope.packageObjects.length = 0;
        $scope.format = '';
        $scope.package = '';

        $scope.manager = '';

        $scope.admin = false;
       
        $scope.apiurl = ApiUrl;      
       
        $scope.baseUrl = '';

        $scope.user = localStorage.getItem("user");


        //console.log('in angular: user - ' + localStorage.getItem("user"));
        if (typeof localStorage.getItem("authenticator") !== 'undefined') {
            $scope.authenticator = localStorage.getItem("authenticator");
        }
        else {
            $scope.authenticator = "";
        }

        

        //console.log('in angular: external authenticator - ' + $scope.authenticator);      

        $http.get('config/server.json?ver=' + new Date().getTime()).
            then(function (data) {

                //alert("api url = " + data.data.apiurl);
                $scope.apiurl = data.data.apiurl;
               
                $scope.baseUrl = data.data.baseUrl; 

                console.log("apiurl=" + $scope.apiurl);
                console.log("baseUrl=" + $scope.baseUrl);

                //this retireves package information from this manager - which is different from getting a forms list from other managers
                $http.get($scope.apiurl + "/api/package")   
                    .then(function (data) {
                        $scope.loading = false;

                       
                        $scope.Packages = data.data;
                        $scope.Filteredlists = $scope.Packages;
                        

                        $scope.format = '';
                        $scope.package = '';

                        if (window.location.href.indexOf("Filler") >= 0) {  
                           
                            $scope.GetFormsOfSelectedManager();
                        }
                      
                    });  //thenFilteredForms



                //IMP - a period in email address causes an error - solution is to add / at the end 
                $http.get($scope.apiurl + "/api/user/" + $scope.user + "/")
                    .then(function (data) {
                        if (data.data == null) {
                            //console.log('null');
                            $scope.admin = false;
                           
                        }
                        else {
                           // console.log('not null');
                            $scope.admin = data.data.Admin;
                            
                        }

                        //console.log('got user info');
                    }, function () {
                        $scope.admin = false;
                    });

                $http.get($scope.apiurl + "/api/configuration")
                    .then(function (data) {
                        console.log('configuration info start');
                        console.log("apiurl=" + $scope.apiurl);
                        console.log("baseUrl=" + $scope.baseUrl);

                        $scope.Managers = data.data.FormManagers;
                        //alert('got managers in SDCTransactionCtrl');
                        for (var i = 0, length = $scope.Managers.length; i < length; i++) {
                            $scope.editingManagers[$scope.Managers[i].Id] = false;
                        }

                        $scope.Receivers = data.data.FormReceivers;
                        for (var j = 0, length1 = $scope.Receivers.length; i < length1; i++) {
                            $scope.editingReceivers[$scope.Receivers[j].Id] = false;
                        }

                        $scope.ValidationPaths = data.data.ValidationPaths;
                        $scope.TransformPaths = data.data.TransformPaths;
                        console.log('cpnfiguration info end');
                        console.log("apiurl=" + $scope.apiurl);
                        console.log("baseUrl=" + $scope.baseUrl);
                    });  //then

            });

        $scope.selectFormat = function (format, index) {

            //console.log('selectFormt');
            angular.forEach($scope.packageObjects, function (value, key) {
                value.selected = false;
                value.format = '';
            }
            );

            //console.log('selectFormt-1');

            $scope.packageObjects[index].format = format;
            $scope.packageObjects[index].selected = true;

            if (format)   //check if null, empty or undefined
            {
                //console.log('setting');
                $scope.package = $scope.packageObjects[index].packageid;
                $scope.format = format;
            }
            else {

                $scope.format = '';
            }
               
            //console.log('selectFormt-2');
           

           
        }

        $scope.selectPackage = function(index)
        {
          
            $scope.package = $scope.packageObjects[index].packageid;
            //console.log('selectPackage');

            angular.forEach($scope.packageObjects, function (value, key) {
                value.selected = false;
                value.format = '';
            }
            );

            $scope.packageObjects[index].selected = true;
          
        };

        $scope.test1 = function (param) {
         
            alert('in test1: ' + param);
        };

        $scope.filterRows = function (search) {

            $scope.Filteredlists = $scope.Packages.filter(function (obj) {
                return (obj.PackageName.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.PackageID.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.FormName.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.AgencyName.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.FormID.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.ValidationPath.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.TransformPath.toUpperCase().indexOf(search.toUpperCase()) >= 0);
            });

            $scope.packageObjects.length = 0;
            angular.forEach($scope.Filteredlists, function (value, key) {
                $scope.packageObjects.push({ 'index': key, 'packageid': value.PackageID, 'format': '', 'selected': false });
            }
            );
        };

        $scope.filterForms = function (search) {
            
            $scope.FilteredForms = $scope.formslist.filter(function (obj) {
               
                return (obj.item.id.toUpperCase().indexOf(search.toUpperCase()) >= 0
                );
            });
            //console.log('filterForms');
            $scope.packageObjects.length = 0;
            angular.forEach($scope.FilteredForms, function (value, key) {
                $scope.packageObjects.push({ 'index': key, 'packageid': value.item.id, 'format': '', 'selected': false });
            }
            );
        };

        //console.log('filterForms-1');
      
        $scope.toggleManagersedit = function ($event, id) {        
            
           

            if ($event.target.tagName == "BUTTON") {
                $scope.editingManagers[id] = !$scope.editingManagers[id];
                editingManagerName = $scope.Managers[id - 1].Name;
                editingManagerUrl1 = $scope.Managers[id - 1].Url;
                editingManagerUrl2 = $scope.Managers[id - 1].FormlistUrl;

                if ($scope.editingManagers[id] == true) {
                    $event.target.innerHTML = 'Save';
                    var tr = $event.target.parentNode.parentNode;
                    if(tr.tagName=="TR")
                        tr.getElementsByTagName("BUTTON")[1].innerHTML = "Cancel";
                }
                else {
                    $event.target.innerHTML = 'Update';
                    var tr = $event.target.parentNode.parentNode;
                    if (tr.tagName == "TR")
                        tr.getElementsByTagName("BUTTON")[1].innerHTML = "Remove";
                    //now send updated managers
                    $scope.UpdateManagers($event);
                }
            }
            else {
                //alert('test');
            }
            


            $event.stopPropagation();
            $event.preventDefault();
        };

        $scope.toggleReceiversedit = function ($event, id) {

            if ($event.target.tagName == "BUTTON") {
                $scope.editingReceivers[id] = !$scope.editingReceivers[id];
               
                editingReceiverName = $scope.Receivers[id - 1].Name;
                editingReceiverUrl = $scope.Receivers[id - 1].Url;
                editingReceiverCOR = $scope.Receivers[id - 1].SupportsScript;

                if ($scope.editingReceivers[id] == true) {
                    $event.target.innerHTML = 'Save';
                    var tr = $event.target.parentNode.parentNode;
                    if (tr.tagName == "TR")
                        tr.getElementsByTagName("BUTTON")[1].innerHTML = "Cancel";
                }
                else {
                    $event.target.innerHTML = 'Update';
                    var tr = $event.target.parentNode.parentNode;
                    if (tr.tagName == "TR")
                        tr.getElementsByTagName("BUTTON")[1].innerHTML = "Remove";
                    $scope.UpdateReceivers($event);
                }
            }

           

            $event.stopPropagation();
            $event.preventDefault();

        };

        $scope.addReceiver = function ($event) {
            $scope.newreceiver.Id = 0;


            var temp = angular.copy($scope.newreceiver);
            $scope.Receivers.push(temp);

            $scope.UpdateReceivers($event);
            //clear
            $scope.newreceiver.Name = '';
            $scope.newreceiver.Url = '';
            $scope.newreceiver.SupportsScript = false;

            $event.stopPropagation();
            $event.preventDefault();
        };

        $scope.deleteManager = function ($event, index) {
            console.log(index);
            console.log($scope.editingManagers[index]);
            if ($scope.editingManagers[index] == true) {
                $scope.editingManagers[index] = false;
                var tr = $event.target.parentNode.parentNode;
                $scope.Managers[index - 1].Name = editingManagerName;
                $scope.Managers[index - 1].Url = editingManagerUrl1;
                $scope.Managers[index - 1].FormlistUrl = editingManagerUrl2;

                if (tr.tagName == "TR") {
                    tr.getElementsByTagName("BUTTON")[1].innerHTML = "Remove";
                    tr.getElementsByTagName("BUTTON")[0].innerHTML = "Update";
                }
                   
                return;
            }
            var r = confirm("Delete " + $scope.Managers[index-1].Name + '?');
            if (r === true) {
                //remove from collection        
                $scope.Managers.splice(index-1, 1);

                $scope.UpdateManagers($event);

            }


            $event.stopPropagation();
            $event.preventDefault();
        };

        $scope.deleteReceiver = function ($event, index) {
            console.log(index);
            console.log($scope.editingReceivers[index])
            if ($scope.editingReceivers[index] == true) {
                $scope.editingReceivers[index] = false;
                var tr = $event.target.parentNode.parentNode;
                $scope.Receivers[index - 1].Name = editingReceiverName;
                $scope.Receivers[index - 1].Url = editingReceiverUrl;
                $scope.Receivers[index - 1].SupportsScript = editingReceiverCOR;

                if (tr.tagName == "TR") {
                    tr.getElementsByTagName("BUTTON")[1].innerHTML = "Remove";
                    tr.getElementsByTagName("BUTTON")[0].innerHTML = "Update";
                }

                return;
            }

            var r = confirm("Delete " + $scope.Receivers[index-1].Name + '?');

            if (r === true) {
                //remove from collection        
                $scope.Receivers.splice(index-1, 1);

                $scope.UpdateReceivers($event);
            }


            $event.stopPropagation();
            $event.preventDefault();
        };


        $scope.addManager = function ($event) {
            $scope.newmanager.Id = 0;


            var temp = angular.copy($scope.newmanager);


            $scope.Managers.push(temp);

            $scope.UpdateManagers($event);


            $event.stopPropagation();
            $event.preventDefault();
        };

        $scope.GetXml = function (id) {
            //console.log(id);

            id = encodeURIComponent(id);
           
            var config = {
                headers: {
                    'Content-Type': 'text/xml',
                    'Accept': 'text/xml'
                }
            };

            $http.get('config/server.json').
                then(function (data) {
                    $scope.apiurl = data.data.apiurl;
                    $scope.baseUrl = data.data.baseUrl;
                   
                    //$http.get($scope.apiurl + '/api/forms/' + id + '/xml', config)
                    $http.get($scope.apiurl + '/api/forms/xml?id=' + id, config)
                        .then(function (data) {

                            $scope.Xml = data.data;
                          

                            var Url = $scope.baseUrl + "/GetXml.aspx?PackageId=" + id;

                            $window.location.href = Url;

                        });  //then
                });

            $scope.msg = 'clicked';
        };

        $scope.getManagerById = function (Id) {
           // console.log('in getManagerById');
            if ($scope.Managers) {
                //console.log('manager is defined');
                return $scope.Managers.filter(function (obj) {
                    return (obj.Id == Id);
                });
            }
           
        };

        $scope.GetHtml = function (id) {
           // console.log(id);
           
            //console.log(id);
           
            $http.get('config/server.json').
                then(function (data) {
                    $scope.apiurl = data.data.apiurl;
                    $scope.baseUrl = data.data.baseUrl;
                    id = encodeURIComponent(id);
                   
                    $http.get($scope.apiurl + '/api/package?id=' + id)
                    //$http.get($scope.apiurl + '/api/package/' + id)
                        .then(function (data) {

                            //$scope.Html = data.data;
                           
                            //console.log(data.data);
                            //var Url = $scope.baseUrl + "/FormHtml.aspx?PackageId=" + id + '&transformpath=' + data.data.TransformPath;
                            var Url = $scope.baseUrl + "/GetHtml.html?PackageId=" + id;
                           
                            $window.location.href = Url;
                            //console.log(data.data);

                        });  //then

                });

            $scope.msg = 'clicked';
        };

        
        $scope.GetFormsOfSelectedManager = function ($event) {

            //console.log('in GetFormsOfSelectedManager');
            var m = localStorage.getItem("fillerSelectedManager");
            $scope.GetFormslist($event, m);

        };

        $scope.GetFormslist = function ($event, manager) {
            $scope.wait = true;
            $scope.selectedManager = manager;

           

            //console.log('cleared the list');
            $http.get($scope.apiurl + '/api/formmanager/' + manager)
                .then(function (data) {

                    var url = data.data.FormlistUrl;

                   //data from FormlistUrl is going to be different
                    //depending on -- change required here
                    if (url != "") {
                        $http.get(url)
                            .then(function (data) {
                                if (data.data.entry == null) {
                                    console.log('FHIR format');
                                }

                               

                                $scope.formslist = data.data.entry;
                                $scope.FilteredForms = $scope.formslist;
                                $scope.formslist.forEach(function (x) {
                                    //console.log(x.item.id);
                                });

                                //clear the list first
                                $scope.packageObjects = [{ index: 0, packageid: '', format: '', selected: false }];
                                $scope.packageObjects.length = 0;

                                angular.forEach($scope.FilteredForms, function (value, key) {
                                    $scope.packageObjects.push({ 'index': key, 'packageid': value.item.id, 'format': '', 'selected': false });
                                }
                                );
                            });  //then

                        $scope.wait = false;
                    }
                    else {
                        $scope.packageObjects.length = 0;
                        $scope.wait = false;
                    }


                    if (typeof $event !== 'undefined') {

                        $event.stopPropagation();
                        $event.preventDefault();
                    }
                    $scope.wait = false;
                });  //then






        };

        $scope.Test = function () {
            console.log('test');
        };

        $scope.GetForms = function (manager) {
            $scope.wait = true;
            $scope.selectedManager = manager;

            //clear the list first
            $scope.packageObjects = [{ index: 0, packageid: '', format: '', selected: false }];
            $scope.packageObjects.length = 0;

            $http.get('config/server.json').
                then(function (data) {
                    $scope.apiurl = data.data.apiurl;

                    $scope.baseUrl = data.data.baseUrl;

                    $http.get($scope.apiurl + '/api/formmanager/' + manager)
                        .then(function (data) {

                            var url = data.data.FormlistUrl;

                            //data from FormlistUrl is going to be different
                            //depending on -- change required here
                            if (url != "") {
                                $http.get(url)
                                    .then(function (data) {
                                        if (data.data.entry == null) {
                                            console.log('FHIR format');
                                        }
                                        $scope.formslist = data.data.entry;
                                        $scope.FilteredForms = $scope.formslist;
                                        $scope.formslist.forEach(function (x) {
                                            //console.log(x.item.id);
                                        });

                                        angular.forEach($scope.FilteredForms, function (value, key) {
                                            $scope.packageObjects.push({ 'index': key, 'packageid': value.item.id, 'format': '', 'selected': false });
                                        }
                                        );
                                    });  //then


                            }
                            else {
                                $scope.packageObjects.length = 0;

                            }

                        });  //then
                });

            //console.log('in GetForms');
            
        };

        $scope.selectManager = function ($event, manager) {

            //window.location.href = "FormFillerStep2.html";
            $scope.fillerSelectedManager = manager.Id;
            localStorage.setItem("fillerSelectedManager", manager.Id); 
            //console.log('in selectManager: ');
            setActive(document.getElementById("navFormFiller"));

            //
           // console.log(manager);
            if (manager.FormlistUrl) {
                //console.log('in select: ' + manager.FormlistUrl);
                $scope.GetFormslist($event, manager.Id);
            }
            else {
                //console.log('no formslisturl');
                //console.log($scope.fillerSelectedManager);
                $scope.FilteredForms = [];
                $scope.packageObjects.length=0;
                $scope.formslist = [];                
            }
        };

        $scope.onSelectionChange = function (item) {

            alert(item);
        };

        $scope.submitResult = function ($event, list) {
            var selectedReceivers = [];
            angular.forEach(list, function (value, key) {
              

                if (list[key].selected == list[key].Id) {
                   
                    selectedReceivers.push(list[key].selected);
                }
            });

            if (selectedReceivers.length > 0)
                console.log(selectedReceivers);
            else
                console.log('no value');

            $event.stopPropagation();
            $event.preventDefault();

            return selectedReceivers;
        };

        function getSelectedReceivers(list) {
            var selectedReceivers = [];
            angular.forEach(list, function (value, key) {


                if (list[key].selected == list[key].Id) {

                    selectedReceivers.push(list[key].selected);
                }
            });

           


            return selectedReceivers;
        }

       
        $scope.GetForm = function ($event, id, format, manager, receivers, prepop) {

           
            

            manager = localStorage.getItem("fillerSelectedManager");
            receivers = getSelectedReceivers(receivers);

            if (format == 1)
                format = "xml";
            if (format == 2)
                format = "html";
            if (format == 3)
                format = "url";

            if (id == "") {
                alert("You must select/enter a package");
                $event.stopPropagation();
                $event.preventDefault();
                return;
            }

            if (format == "xml" && receivers == "") {
                alert("You must select one or more receivers");
                $event.stopPropagation();
                $event.preventDefault();
                return;
            }
               
            if (manager == "") {
                alert("You must select a manager");
                $event.stopPropagation();
                $event.preventDefault();
                return;

            }
               
            if (format == "") {
                alert("You must select a format");
                $event.stopPropagation();
                $event.preventDefault();
                return;
            }
                


            $event.stopPropagation();
            $event.preventDefault();

            var data = {
                id: $scope.package,
                format: format,
                manager: manager,
                receivers: receivers,
                prepop: prepop
            };

           //console.log(JSON.stringify(data));

            //Call the services

            var Url;


            if (format == "xml")
                Url = $scope.baseUrl + "/SDCForm.aspx";
            if (format == "html")
                Url = $scope.baseUrl + "/SDCFormHTML.aspx";
            if (format == "url")
                Url = $scope.baseUrl + "/SDCFormUri.aspx";



            $http.post(Url, JSON.stringify(data)).then(function (response) {

                if (response.data) {
                    $window.location.href = Url;
                }

                $scope.msg = "Post Data Submitted Successfully!";

            }, function (response) {

                $scope.msg = "Service not Exists";

                $scope.statusval = response.status;

                $scope.statustext = response.statusText;

                $scope.headers = response.headers();

            });

        };


        $scope.UpdatePackage = function (id) {
          
            var Url = $scope.baseUrl + "/UpdatePackage.aspx?packageid=" + encodeURIComponent(id);
            
           // console.log(encodeURIComponent(id));

            $window.location.href = Url;
        };

        $scope.DeletePackage = function (id) {
            var r = confirm("Delete " + id + '?');
            if (r == true) {
                var token_id = sessionStorage.getItem("token");
                $http.get('config/server.json').
                    then(function (data) {
                        $scope.apiurl = data.data.apiurl;
                        $http.delete($scope.apiurl + '/api/package', { params: { id: id, userid: $scope.user, token: token_id} })
                            .then(function (data) {
                               
                                $http.get($scope.apiurl + "/api/package")
                                    .then(function (data) {
                                        $scope.loading = false;

                                        $scope.Packages = data.data;

                                        $scope.Filteredlists = $scope.Packages;
                                    });
                            });
                    });


            }


        };

        $scope.UpdateReceivers = function ($event) {

            $http.get('config/server.json').
                then(function (data) {
                    $scope.apiurl = data.data.apiurl;
                    $http.post($scope.apiurl + '/api/Configuration/UpdateReceivers', $scope.Receivers)
                        .then(function (data) {
                            //clear
                            $scope.newreceiver.Name = '';
                            $scope.newreceiver.Url = '';
                            $scope.newreceiver.SupportsScript = false;
                            //alert("Receivers updated");
                        });
                    $event.stopPropagation();
                    $event.preventDefault();
                });


        };

        $scope.UpdateManagers = function ($event) {
            $http.get('config/server.json').
                then(function (data) {
                    $scope.apiurl = data.data.apiurl;
                    //alert($scope.apiurl);
                    $http.post($scope.apiurl + '/api/Configuration/UpdateManagers', $scope.Managers)
                        .then(function (data) {
                            //clear
                            $scope.newmanager.Name = '';
                            $scope.newmanager.Url = '';
                            $scope.newmanager.FormlistUrl = '';

                            //alert("Managers updated");
                        },
                        function (data) {
                            // Handle error here
                            console.log(data);
                        });

                    $event.stopPropagation();
                    $event.preventDefault();
                });
        };		
		//this event fires when included content is loaded
		$scope.$on('$includeContentLoaded', function(eve,uri) {
           
			window.document.getElementById("username").innerText = localStorage.getItem("user");
			
            var currentUrl = $location.absUrl().toLowerCase();
           // console.log(currentUrl);
            if(currentUrl.indexOf("home.html")>=0)
            {			
				setActive(document.getElementById("navHome"));
            }
            if (currentUrl.indexOf("formmanager.html") >= 0) {
               
                setActive(document.getElementById("navFormManager"));
            }
			if(currentUrl.indexOf("formfiller")>=0)			
				setActive(document.getElementById("navFormFiller"));
			if(currentUrl.indexOf("configure")>=0)		
                setActive(document.getElementById("navConfigure"));

            if (currentUrl.indexOf("sdcform") >= 0) {
                setActive(document.getElementById("navFormFiller"));
            }

            if (currentUrl.indexOf("sdcformhtml") >= 0) {
                setActive(document.getElementById("navFormFiller"));
            }

            if (currentUrl.indexOf("sdcformurl") >= 0) {
                setActive(document.getElementById("navFormFiller"));
            }

            if (currentUrl.indexOf("updatepackage") >= 0 || currentUrl.indexOf("getxml") >= 0 || currentUrl.indexOf("gethtml") >= 0 ) {
                setActive(document.getElementById("navFormManager"));

                //console.log("*********************************");
                //console.log(document.getElementById("navFormManager"));
                //console.log("**************" + currentUrl + "***************");
               // console.log("*********************************");
            }
               
            if (currentUrl.indexOf("uploadpackage") >= 0)
                setActive(document.getElementById("navFormManager"));

            //if (currentUrl.indexOf("Filler") >= 0)
            //    setActive(document.getElementById("navFormFiller"));
		});


        
        if (window.location.href.indexOf("Filler") > 0) {
            //alert(window.location.href);
            //$scope.GetFormsOfSelectedManager();
        }
    });  //controller
	
	
        

    app.controller("SDCSubmitCtrl", function ($scope, $location, $http, $window, $sce, $route) { 
        $scope.dataLoading = true;

        $scope.user = localStorage.getItem("user");

        $http.get('config/server.json').
            then(function (data) {
                $scope.apiurl = data.data.apiurl;
                $http.get($scope.apiurl + '/api/submission')
                    .then(function (data) {

                        $scope.Submissions = data.data;
                        $scope.FilteredSubmissions = data.data;
                        $scope.dataLoading = false;


                    });  //then

                //managers always need to be visible - can we do it outside of individual controller?
                $http.get($scope.apiurl + "/api/configuration")
                    .then(function (data) {
                        $scope.Managers = data.data.FormManagers;
                        //alert('got managers in submitctrl');
                        //for (var i = 0, length = $scope.Managers.length; i < length; i++) {
                        //    $scope.editingManagers[$scope.Managers[i].Id] = false;
                        //}

                        //$scope.Receivers = data.data.FormReceivers;
                        //for (var j = 0, length1 = $scope.Receivers.length; i < length1; i++) {
                        //    $scope.editingReceivers[$scope.Receivers[j].Id] = false;
                        //}

                        $scope.ValidationPaths = data.data.ValidationPaths;
                        $scope.TransformPaths = data.data.TransformPaths;

                    });  //then

                //IMP - a period in email address causes an error - solution is to add / at the end 
                $http.get($scope.apiurl + "/api/user/" + $scope.user + "/")
                    .then(function (data) {
                        if (data.data == null) {
                            $scope.admin = false;
                        }
                        else {
                            $scope.admin = data.data.Admin;
                        }

                        //console.log('got user info');
                    }, function () {
                        $scope.admin = false;
                    });
            });

        $scope.selectAllSubmissions = function () {
            $scope.isAll = !$scope.isAll;
            angular.forEach($scope.Submissions, function (trans) {

                trans.selected = $scope.isAll;
            });
        };

        $scope.filterSubmissions = function (search) {

            $scope.FilteredSubmissions = $scope.Submissions.filter(function (obj) {
               
                return (obj.TransactionId.indexOf(search) >= 0
                    || obj.SubmitTime.indexOf(search) >= 0
                    || obj.FormName.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.FormId.indexOf(search) >= 0
                    || obj.Validated.toString().toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.Message.toUpperCase().indexOf(search.toUpperCase()) >= 0                    
                    || obj.IpAddress.indexOf(search) >= 0
                   );
            });

           
        };

        $scope.removeSubmission = function (index) {
            var TransactionId = $scope.Submissions[index].TransactionId;

            if (confirm("Delete Transaction Id = " + TransactionId)) {

                //console.log('Removing TransactionId = ' + TransactionId);
                $scope.Submissions.splice(index, 1);
                var token = sessionStorage.getItem("token");
                //TransactionIds=
                var config = {
                    headers: {

                        'Authorization': 'Bearer 123',
                        "X-Login-Ajax-call": 'true'
                    }
                };

                var promise = $http.delete($scope.apiurl + "/api/Submission/Delete?TransactionIds=" + TransactionId);
                $http.delete($scope.apiurl + "/api/Submission/Delete?TransactionIds=" + TransactionId + "&userid=" + $scope.user + "&token=" + token, config)
                //$http.delete($scope.apiurl + "/api/Submission/Delete?TransactionIds=" + TransactionId)
                    .then(function (msg) {
                        alert("Removed Transaction Id = " + TransactionId);
                    },
                        function (err) {
                            console.log("Error removing transaction id = " + TransactionId);
                            console.log(err);
                        }
                    );
            }


        };

        $scope.removeAllSelected = function () {
            var remainingList = [];
            var selectedIds = new Array();
            angular.forEach($scope.Submissions, function (trans) {
                if (trans.selected) {
                    selectedIds.push(trans.TransactionId);
                }
                else {
                    remainingList.push(trans);
                }
            });
            if (selectedIds.length == 0) {
                alert("Please select transactions to delete");
                return;
            }
            var token = sessionStorage.getItem("token");
            var config = {
                headers: {

                    'Authorization': 'Bearer 123',
                    "X-Login-Ajax-call": 'true'
                }
            };
            $http.delete($scope.apiurl + "/api/Submission/Delete?TransactionIds=" + selectedIds + "&userid=" + $scope.user + "&token=" + token, config)
            //$http.delete($scope.apiurl + "/api/Submission/Delete?TransactionIds=" + selectedIds)
                .then(function (msg) {
                    //alert("Removed Transaction Id = " + TransactionId);
                    $scope.Submissions = remainingList;
                },
                    function (err) {
                        console.log("Error removing transaction id = " + TransactionId);
                        console.log(err);
                        $scope.Submissions = remainingList;
                    }
                );

        };
		   
		   //this event fires when included content is loaded
        $scope.$on('$includeContentLoaded', function (eve, uri) {
            
            var currentUrl = $location.absUrl();
            
            currentUrl.indexOf("submission");
            window.document.getElementById("username").innerText = localStorage.getItem("user");
            $scope.user = localStorage.getItem("user");
            setActive(document.getElementById("navSubmissions"));
               
            if (currentUrl.indexOf("submission") >= 0 ) {
                    setActive(document.getElementById("navSubmissions"));

                    //console.log("*********************************");
                    //console.log(document.getElementById("navSubmissions"));
                    //console.log("**************" + currentUrl + "***************");
                    //console.log("*********************************");
            }
          
        });

        $scope.ShowSubmitXml = function (transaction_id, user) {
           
            window.location.href = "submissiongetxml.aspx?transaction_id=" + transaction_id + "&User=" + user;
        };

        $scope.ShowSubmitHtml = function (transaction_id) {
           
            window.location.href = "submissiongethtml.aspx?transaction_id=" + transaction_id;
        };
    });

    app.controller("TransactionsCtrl", function ($scope, $location, $http, $window, $sce, $route) {
        $scope.dataLoading = true;

        //console.log('TransactionsCtrl started');

        $scope.user = localStorage.getItem("user");

        $http.get('config/server.json').
            then(function (data) {
                $scope.apiurl = data.data.apiurl;
                $http.get($scope.apiurl + '/api/transactionlog')
                    .then(function (data) {

                        $scope.Transactions = data.data;
                        $scope.FilteredTransactions = data.data;

                        $scope.dataLoading = false;



                    });  //then

                //managers always need to be visible - can we do it outside of individual controller?
               
                $http.get($scope.apiurl + "/api/configuration")
                    .then(function (data) {
                        //console.log('got managers');
                        $scope.Managers = data.data.FormManagers;


                    });  //then

                $http.get($scope.apiurl + "/api/user/" + $scope.user + "/")
                    .then(function (data) {
                        if (data.data == null) {
                            $scope.admin = false;
                        }
                        else {
                            $scope.admin = data.data.Admin;
                        }

                        //console.log('got user info');
                    }, function () {
                        $scope.admin = false;
                    });
            });

        $scope.selectAllTransactions = function () {
            $scope.isAll = !$scope.isAll;
            angular.forEach($scope.Transactions, function (trans) {

                trans.selected = $scope.isAll;
            });
        };

        $scope.filterTransactions = function (search) {

            $scope.FilteredTransactions = $scope.Transactions.filter(function (obj) {

                return (obj.TransactionId.indexOf(search) >= 0
                    || obj.TransactionType.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.Actor.toUpperCase().indexOf(search.toUpperCase()) >= 0
                    || obj.SourceIp.indexOf(search) >= 0
                    || obj.DateCreated.indexOf(search) >= 0
                   
                );
            });


        };

        $scope.removeTransaction = function (index) {
            var TransactionId = $scope.Transactions[index].TransactionId;

            

            if (confirm("Delete Transaction Id = " + TransactionId)) {

                var config = {
                    headers: {
                     
                        'Authorization': 'Bearer 123',
                        "X-Login-Ajax-call": 'true'
                    }
                };

                //console.log('Removing TransactionId = ' + TransactionId);
                $scope.Transactions.splice(index, 1);
                var token = sessionStorage.getItem("token");

                //console.log(token);
                //var promise = $http.delete($scope.apiurl + "/api/TransactionLog/Delete?TransactionIds=" + TransactionId + "&userid=" + $scope.user + "&token=" + "123");
                $http.delete($scope.apiurl + "/api/TransactionLog/Delete?TransactionIds=" + TransactionId + "&userid=" + $scope.user + "&token=" + token, config)
                    .then(function (msg) {
                        alert("Removed Transaction Id = " + TransactionId);
                    },
                    function (err) {
                        console.log("Error removing transaction id = " + TransactionId);
                        console.log(err);
                    }
               );

              
            }
           
            
        };

        $scope.removeAllSelected = function () {
            var remainingList = [];
            var selectedIds = new Array();
            angular.forEach($scope.Transactions, function (trans) {
                if (trans.selected) {
                    selectedIds.push(trans.TransactionId);
                }
                else {
                    remainingList.push(trans);
                }
            });
            if (selectedIds.length == 0) {
                alert("Please select transactions to delete");
                return;
            }

            //var TransactionId = $scope.Transactions[index].TransactionId;

            var config = {
                headers: {

                    'Authorization': 'Bearer 123',
                    "X-Login-Ajax-call": 'true'
                }
            };

            var token = sessionStorage.getItem("token");

            //$http.delete($scope.apiurl + "/api/TransactionLog/Delete?TransactionIds=" + selectedIds)
            $http.delete($scope.apiurl + "/api/TransactionLog/Delete?TransactionIds=" + selectedIds + "&userid=" + $scope.user + "&token=" + token, config)
                .then(function (msg) {
                    //alert("Removed Transaction Id = " + TransactionId);
                    $scope.Transactions = remainingList;
                },
                    function (err) {
                        console.log("Error removing transaction id = " + selectedIds);
                        console.log(err);
                        $scope.Transactions = remainingList;
                    }
                );
           
        };
		   //this event fires when included content is loaded
		  //this event fires when included content is loaded
        $scope.$on('$includeContentLoaded', function (eve, uri) {
            //alert('here');
            window.document.getElementById("username").innerText = localStorage.getItem("user");
            $scope.user = localStorage.getItem("user");
			    var currentUrl = $location.absUrl();
			    setActive(document.getElementById("navTransactions"));
            if (currentUrl.indexOf("getxml") >= 0) {
                setActive(document.getElementById("navTransactions"));

                //console.log("*********************************");
                //console.log(document.getElementById("navTransactions"));
                //console.log("**************" + currentUrl + "***************");
                //console.log("*********************************");
            }
		    });
    });

	
	 
    app.controller("FormHtmlCtrl", function ($scope, $location, $http, $window, $sce, $route) {  
        
      
        function getUrlParameter (param, dummyPath) {
            var sPageURL = dummyPath || window.location.search.substring(1),
                sURLVariables = sPageURL.split(/[&||?]/),
                res;

            for (var i = 0; i < sURLVariables.length; i += 1) {
                var paramName = sURLVariables[i],
                    sParameterName = (paramName || '').split('=');

                if (sParameterName[0] === param) {
                    res = sParameterName[1];
                }
            }

            return res;
        }
    });
    
    

    
    
})(myApp);
