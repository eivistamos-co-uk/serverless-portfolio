fetch('https://qv04bztc7b.execute-api.eu-west-2.amazonaws.com/prod/count')
    .then(response => response.json())
    .then(data => {
        document.getElementById('count').textContent = data.count;
    })
    .catch(error => {
        console.error('Error fetching visitor count:', error);
    });