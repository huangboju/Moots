
var helloWorld = "Hello world!";

function getFullName(firstName, lastName) {
    return firstName + " " + lastName;
}

function sendDict(dict) {
    consoleLog(dict.string);
}

function maxMinAverage(values) {
    var max = Math.max.apply(null, values);
    var min = Math.min.apply(null, values);
    var average = null;
    if (values.length > 0) {
        var sum = 0;
        for (var i=0; i < values.length; i++) {
            sum += values[i];
        }
        
        average = sum / values.length;
    }
    
    return {
        "max" : max,
        "min" : min,
        "average" : average
    };
}

function generateLuckyNumbers() {
    
    consoleLog("打印东东啊");

    var luckyNumbers = [];
    while (luckyNumbers.length != 6) {
        var randomNumber = Math.floor((Math.random() * 50) + 1);
        if (!luckyNumbers.includes(randomNumber)) {
            luckyNumbers.push(randomNumber);
        }
    }
    
    handleLuckyNumbers(luckyNumbers);
}

function convertMarkdownToHTML(source) {
    var converter = new showdown.Converter();
    var htmlResult = converter.makeHtml(source);
    consoleLog(htmlResult);
}

function parseiPhoneList(originalData) {
    var results = Papa.parse(originalData, { header: true });
    if (results.data) {
        var deviceData = [];
        
        for (var i=0; i < results.data.length; i++) {
            var model = results.data[i]["Model"];
            
            var deviceInfo = DeviceInfo.initializeDeviceWithModel(model);

            DeviceInfo.testWithModel(model)
            
            deviceInfo.initialOS = results.data[i]["Initial OS"];
            deviceInfo.latestOS = results.data[i]["Latest OS"];
            deviceInfo.imageURL = results.data[i]["Image URL"];
            
            deviceData.push(deviceInfo);
        }
        
        return deviceData;
    }
    
    return null;
}

