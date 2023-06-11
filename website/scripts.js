const myURL = "https://sj5qwca5eh.execute-api.eu-west-1.amazonaws.com/dev"

function hasVisitedBefore() {
    return localStorage.getItem('visited') === 'true';
}

function setVisited() {
    localStorage.setItem('visited', 'true');
}

function fetchCount() {
    return fetch(myURL)
        .then((response) => {
            if (!response.ok) {
                throw new Error('Failed to fetch count');
            }
            return response.json();
        });
}

function updateCount() {
    if (!hasVisitedBefore()) {
        fetch(myURL, { method: 'POST' }) // Perform a POST request to increment the count
        .then((response) => {
            if (!response.ok) {
                throw new Error('Failed to update count');
            }
            return fetchCount();
        })
            .then((count) => {
                document.getElementById('counter').innerHTML = count;
            })
            .catch((error) => {
                console.error(error);
        });
    }
}

function getCount() {
    fetchCount()
    .then((count) => {
    document.getElementById('counter').innerHTML = count;
    })
    .catch((error) => {
    console.error(error);
    });
}

updateCount();
getCount();