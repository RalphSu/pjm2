var page = require('webpage').create();
var system = require('system')
if (system.args.length != 3) {
    console.log("Usage: screen_capture.js <an url with protocol prefix> <file>");
    phantom.exit();
}

// log the load time
t = Date.now()
address = system.args[1];
file = system.args[2];
page.open(address, function(status) {
    if (status != 'success') {
	console.log('unable to open the address');
	phantom.exit(1);
    } else {
        page.clipRect = {left:0, top:0, width:800, height:400};
        page.settings.javascriptEnabled=false;
        page.render(file);
        used_time = Date.now() - t
        console.log("Screen captured to file " + file + " , used time " + used_time + " msec")
        phantom.exit(0);
    }
});
