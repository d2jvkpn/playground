// 'https://example.com/data'

async function fetchData(url) {
  const response = await fetch(url);
  if (!res) {
    throw new TypeError("empty response");
  }

  let ct = response.headers.get("Content-Type");
  console.log(`~~~ response: status=${response.status}, content-type=${ct}`);  

  const data = await response.json();
  return data;
}

function handleFetchErr(err) {
  if (err instanceof TypeError && err.message.startsWith("NetworkError")) {
    console.error("NetworkError: request failed");
  } else if (err instanceof TypeError)  {
    console.error(`TypeError: ${err.message}`);
  } else if (err instanceof SyntaxError)  {
    console.error(`SyntaxError: invalid response data`);
  } else {
    console.error(`UnexpectedError: ${err}`);
  }
}

function f1(url) {
  fetchData(url).then(data => {
    console.log(`~~~ got response data: ${JSON.stringify(data)}`);
  }).catch(err => {
    handleFetchErr(err);
  });
}

//function f2(url) {
//  try {
//    const result = await fetchData(url);
//    return result;
//  } catch (err) {
//    throw err;
//  }
//}

function request(path, callback=null) {
  let now = new Date();
  let options = {method: "GET", headers: {"X-TZ-Offset": now.getTimezoneOffset()}}
  // options.headers["Authorization"] = `Bearer ${token}`;

  fetch(`${path}`, options)
    .then(response => {
      let contentType = response.headers.get("Content-Type");
      console.log(`~~~ got response: ${response.status}, ${response.length}, ${contentType}`);

      // response.blob().then((myBlob) => {
      //   const objectURL = URL.createObjectURL(myBlob);
      //   myImage.src = objectURL;
      // });

      if (!contentType || !contentType.startsWith("application/json")) {
        throw new TypeError("response isn't json");
      }

      return response.json();
    }).then(res => {
      // TODO: handle res, return early
      if (callback) callback(res);
    })
    .catch(function (err) {
      console.error(`!!! http ${options.method} ${path}: ${err}`);
      handleFetchErr(err)
    });
}

console.log(`--> before request`);

request("http://localhost:8000/data.json", function(d) {
  console.log(`~~~ got data: ${JSON.stringify(d)}`);
});

console.log(`--> after request`);
