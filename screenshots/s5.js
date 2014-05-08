var page = require('webpage').create();
page.clipRect = {left:0, top:0, width:800, height:600};
page.settings.javascriptEnabled=false;
page.open('index.html', function (status) {
    if (status !== 'success') {
        console.log('Unable to access the network!');
    } else {
        //page.evaluate(function () {
            //var body = document.body;
            //body.style.backgroundColor = '#fff';
            //body.querySelector('div#title-block').style.display = 'none';
            //body.querySelector('form#edition-picker-form').parentElement.parentElement.style.display = 'none';
        //});
        page.render('technews.png');
    }
    phantom.exit();
});
