// import logo from './logo.svg';
import { sprintf } from "sprintf-js";
import 'antd/dist/antd.min.css';

import './App.css';
import packageJson from '../package.json';

import Clock from "demo/clock.jsx";
import BrowseImage from "components/browse-image.jsx"
import ExportJSON from "components/export-json.jsx";
import LoadJSON from "components/load-json.jsx";
import { helloWorld, datetime } from "js/utils.js";
import { setHeader, request, setApi } from "js/base.js";
import { loadLang, getSet } from "locales/index.js";

/*
function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}
*/

function App() {
  setHeader(null);

  let url = new URL(window.location.href);
  url = `${url.protocol}//${url.host}`;

  let p = process.env.PUBLIC_URL ? `${process.env.PUBLIC_URL}/data.json` : "/data.json";
  request(`${url}${p}`, {method: "GET", headers: {}}, function(d) {
    if (!d) {
      return;
    }

    setApi(d.apiServer);
    console.log(`==> data: ${JSON.stringify(d)}`);
  });

  localStorage.setItem("loadTime", datetime().rfc3339ms);
  // console.log(`~~~ loadTime: ${localStorage.getItem("loadTime")}`);

  window.UILanguage = loadLang(localStorage.getItem("Language") || navigator.language);
  let langCommon = getSet("common"); // let langCommon = window.UILanguage.common;

  xx();
  console.log(sprintf(langCommon["welcome"], "d2jvkpn"));

  return (
    <div className="App"
      data-app-version={packageJson.version}
      data-app-env={process.env.REACT_APP_ENV}
      data-build-time={process.env.REACT_APP_BuildTime}
    >
      <h4 style={{cursor:"pointer"}} title="click me" onClick={helloWorld}>
        {langCommon["hello"]}, {langCommon["world"]}!
      </h4>

      <Clock duration={1000}/>

      {/*
      <p style={{cursor:"pointer"}}
        onClick={(event) => {
          console.log(`~~~ ${event.target.innerHTML}`);
          console.log(`~~~ ${event.target.previousSibling.innerHTML}`);
        }}
      >
        Click Me
      </p>
      */}

      <BrowseImage />

      <br/>
      <ExportJSON
        title="export"
        prefix="data"
        export={(callback) => {
          let data = {"hello": "world"};
          callback(data);
        }}
      />

      <br/>
      <br/>
      <LoadJSON
        title="import json"
        load={(data) => {
          console.log(`~~~ ${JSON.stringify(data)}`);
        }}
      />
    </div>
  );
}


function xx() {
  console.log(":) xx");
}

export const yy = () => {
  console.log(":) yy");
}

export default App;
