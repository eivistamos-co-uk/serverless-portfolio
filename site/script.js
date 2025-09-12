fetch('/config.js')
  .then(response => response.json())
  .then(config => {
    const API_URL = config.apiUrl;
    return fetch(API_URL);
  })
  .then(res => res.json())
  .then(data => {
    document.getElementById("count").innerText = data.count;
  })