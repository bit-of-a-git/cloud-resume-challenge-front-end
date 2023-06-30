const myURL = " https://fthtevm397.execute-api.eu-west-1.amazonaws.com/dev";

const hasVisitedBefore = () => {
  return document.cookie.includes("visited=true");
};

const setVisited = () => {
  const expirationDate = new Date();
  expirationDate.setMonth(expirationDate.getMonth() + 1); // Sets the cookie to expire one month after the current date
  const expires = expirationDate.toUTCString();
  document.cookie = `visited=true; path=/; expires=${expires}`;
};

const fetchCount = () => {
  return fetch(myURL)
    .then((response) => {
      if (!response.ok) {
        throw new Error(`Failed to fetch count. Response status: ${response.status}`);
      }
      return response.json();
    })
    .catch((error) => {
      console.error(`Error while fetching count: ${error}`);
      throw error;
    });
};

const incrementCount = () => {
  return fetch(myURL, { method: 'POST' })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`Failed to increment count. Response status: ${response.status}`);
      }
    })
    .catch((error) => {
      console.error(`Error while incrementing count: ${error}`);
      throw error;
    });
};

const updateCount = () => {
  if (!hasVisitedBefore()) {
    incrementCount()
      .then(() => fetchCount())
      .then((data) => {
        updateCounterElements(data);
        setVisited();
      })
      .catch((error) => {
        console.error(`Error: ${error}`);
      });
  }
}

const getCount = () => {
  fetchCount()
    .then((data) => {
      updateCounterElements(data);
    })
    .catch((error) => {
      console.error('Error: ${error}');
    });
};

const updateCounterElements = (data) => {
  document.getElementById('hitCount').textContent = data.hit_count;
  document.getElementById('uniqueVisitors').textContent = data.hashed_ip_count;
};

updateCount();
getCount();
