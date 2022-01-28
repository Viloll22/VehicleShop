$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
        else if (item.carListCheck) {

            listCarToSell(item.carToSell)
 
        }

        else if (item.bikeListCheck) {

            listBikeToSell(item.bikeToSell)
 
        }

        else if (item.truckListCheck) {

            listTruckToSell(item.truckToSell)
 
        }
    })







    function listCarToSell(carList) {
				
        car=carList;
        carList=JSON.parse(carList);
        $('#carContent').empty();
	
       
                
        
       
        for (i=0;i<carList.length;i++){
            
            
                    
            $("#carContent").append(`
            <div id="carSlotPrefab">
                    <img src="${carList[i].img}">
                    <h2>${carList[i].label}</h2>
                    <p>$${carList[i].price}</p>
                    <input type="radio" class='date-format-switcher' name="carName" value="`+carList[i].id+`">
            </div>`);

                
                    
        }
       
                 
    }



    function listBikeToSell(bikeList) {
				
        bike=bikeList;
        bikeList=JSON.parse(bikeList);
        $('#bikeContent').empty();
	
       
                
        
       
        for (i=0;i<bikeList.length;i++){
            
            
                    
            $("#bikeContent").append(`
            <div id="carSlotPrefab">
                    <img ur="${bikeList[i].img}">
                    <h2>${bikeList[i].label}</h2>
                    <p>$${bikeList[i].price}</p>
                    <input type="radio" class='date-format-switcher' name="carName" value="`+bikeList[i].id+`">
            </div>`);

                
                    
        }
       
                 
    }



    function listTruckToSell(truckList) {
				
        truck=truckList;
        truckList=JSON.parse(truckList);
        $('#truckContent').empty();
	
       
                
        
       
        for (i=0;i<truckList.length;i++){
            
            
                    
            $("#truckContent").append(`
            <div id="carSlotPrefab">
                    <img src="${truckList[i].img}">
                    <h2>${truckList[i].label}</h2>
                    <p>$${truckList[i].price}</p>
                    <input type="radio" class='date-format-switcher' name="carName" value="`+truckList[i].id+`">
            </div>`);

                
                    
        }
       
                 
    }










   

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://rc_VehicleShop/exit', JSON.stringify({})); // Wenn man ESC triggert er Callback exit in der Main.lua Client
            return
        }
    };
    

    $("#close").click(function () {
        $.post('http://rc_VehicleShop/exit', JSON.stringify({})); 
        return
    })
    
})