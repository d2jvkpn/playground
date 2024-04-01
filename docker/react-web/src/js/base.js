import { message } from "antd";

/*
const Data = {
  loadedAt: null,
  defaultHeaders: {},
  token: "",
  api: "",
  publicUrl: "",
};

function init() {
  if (Data.loadedAt !== null) {
    return;
  }
  Data.loadedAt = new Date();

  Data.api = process.env.REACT_APP_API;

  Data.publicUrl = process.env.PUBLIC_URL.replace(/^\/+|\/+$/g, '');
  Data.publicUrl = Data.publicUrl ? "/" + Data.publicUrl : "";

  console.log(`~~~ REACT_APP_ENV="${process.env.REACT_APP_ENV}"`);
}
*/

const Data = {
  loadedAt: null,
  defaultHeaders: {},
  token: "",
  api: "",
};

function init() {
  if (Data.loadedAt !== null) {
    return;
  }
  Data.loadedAt = new Date();
}

init();

//
export function setApi(addr) {
  if (addr) {
    Data.api = addr;
  }
}

//
export function setHeader(key, value) {
  if (key) {
    Data.defaultHeaders[key] = value;
  }
}

export function setToken(value) {
  Data.token = value;
}

export function post(path, data=null, callback=null) {
  let options = { method: "POST", headers: {...Data.defaultHeaders} };
  options.headers["Content-Type"] = "application/json";

  if (data) {
    options.body = JSON.stringify(data);
  }

  request(`${Data.api}${path}`, options, callback);
}

export function get(path, data=null, callback=null) {
  let options = {method: "GET", headers: {...Data.defaultHeaders} };

  if (data) {
    let arr = [];
    for (const [key, value] of Object.entries(data)) {
      if (value) arr.push(`${key}=${value}`);
    }
    if (arr.length > 0) path += `?${arr.join("&")}`;
  }

  request(`${Data.api}${path}`, options, callback);
}

export function request(path, options, callback=null) {
  if (Data.token) {
    options.headers["Authorization"] = `Bearer ${Data.token}`;
  }

  options.headers["X-TZ-Offset"] = Data.loadedAt.getTimezoneOffset();

  fetch(`${path}`, options)
    .then(response => {
      // if (response.length === 0) {
      //   return null;
      // }
      let contentType = response.headers.get("Content-Type");
      if (!contentType || !contentType.startsWith("application/json")) {
        throw new TypeError("invalid response");
      }

      if (response.action) {
        switch (response.action) {
          case "action::login":
            // localStorage.getItem(name);
            // localStorage.setItem(name, value);
            localStorage.clear();
            window.location.href = "/login";
            return;
          default:
        }
      }

      return response.json();
    }).then(res => {
      if (!res) {
        throw new TypeError("empty response");
      }
      
      if (res.code !== 0 && callback) {
        callback(null, res);
      }
      if (res.code < 0) {
        message.warn(res.msg);
        return;
      }

      if (res.code === 0 && options.method === "GET" && res.data.hasOwnProperty("items")) {
        if (Array.isArray(res.data.items) && res.data.items.length === 0) {
          console.warn("!!! no items");
        }
      }

      if (callback) callback(res, null);
    })
    .catch(function (err) {
      console.error(`!!! http${options.method} ${path}: ${err}`);

      if (err instanceof TypeError && err.message.startsWith("NetworkError")) {
        message.error("NetworkError: request failed");
        return;
      } else if (err instanceof TypeError)  {
        message.error(`TypeError: ${err.message}`);
        return;
      } else if (err instanceof SyntaxError)  {
        message.error(`SyntaxError: invalid response data`);
        return;
      } else {
        message.error(`UnexpectedError: ${err}`);
      }
    });
}
