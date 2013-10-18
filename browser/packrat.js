window.onload = function() {
  var client;
  console.log('Subscribing to ' + location.host + '/faye');
  window.packratClient = client = new Faye.Client(location.origin + '/faye');
  return client.subscribe('/packrat', function(message) {
    console.log('packrat incoming');
    document.getElementById("packrat-css").innerHTML = message.css
  });
};