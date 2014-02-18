var page = require('webpage').create();
var system = require('system')
if (system.args.length != 3) {
    console.log("Usage: screen_capture.js <an url> <file>");
    phantom.exit();
}

// log the load time
t = Date.now()
address = system.args[1];
file = system.args[2];
page.open(address, function() {
    page.render(file);
    used_time = Date.now() - t
    console.log("Screen captured to file " + file + " , used time " + used_time + " msec")
    phantom.exit();
});
