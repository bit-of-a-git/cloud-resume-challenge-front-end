const myURL = "https://afb6q3gz26.execute-api.eu-west-1.amazonaws.com/dev";

const hasVisitedBefore = () => {
  return document.cookie.includes("visited=true");
};

const setVisited = () => {
  document.cookie = "visited=true; path=/";
};

const fetchCount = () => {
  return fetch(myURL)
    .then((response) => {
      if (!response.ok) {
        throw new Error('Failed to fetch count: ${response.status}');
      }
      return response.json();
    });
};

const incrementCount = () => {
  return fetch(myURL, { method: 'POST' })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`Failed to increment count: ${response.status}`);
      }
    });
}

const updateCount = () => {
  if (!hasVisitedBefore()) {
    incrementCount()
      .then(() => fetchCount())
      .then((count) => {
        document.getElementById('counter').innerHTML = count;
        setVisited();
      })
      .catch((error) => {
        console.error(`Error: ${error}`);
      });
  }
}

const getCount = () => {
  fetchCount()
    .then((count) => {
      document.getElementById('counter').innerHTML = count;
    })
    .catch((error) => {
      console.error('Error: ${error}');
    });
};

updateCount();
getCount();
