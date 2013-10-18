window.onload = function() {
  var client;
  console.log('Subscribing to ' + location.host + '/faye');
  window.packratClient = client = new Faye.Client(location.origin + '/faye',
    {timeout: 30}
  );
  client.disable('autodisconnect');
  return client.subscribe('/packrat', function(message) {
    console.log('packrat incoming');
    console.log(message);
    if (message.reload) {
      console.log('reloading...');
      return location.reload()
    }
    else
      document.getElementById("packrat-css").innerHTML = message.css
  });
};