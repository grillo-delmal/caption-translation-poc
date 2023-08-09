document.addEventListener("DOMContentLoaded", function(event) { 
    var cap_0 = document.getElementById("cap_0");
    var cap_1 = document.getElementById("cap_1");
    var tr_es = document.getElementById("es");
    var tr_jp = document.getElementById("jp");

    //connect to the socket server.
    var socket = io();

    //receive details from server
    socket.on('captions', function(result) {
        let i = 0;
        while (i < result.captions.length) {
            if(i == 0){
                cap_0.innerHTML = result.captions[i];
            }
            else{
                cap_1.innerHTML = result.captions[i];
            }
            i++;
        }
        tr_es.innerHTML = result.tr.es; 
        tr_jp.innerHTML = result.tr.jp; 
    });
});
