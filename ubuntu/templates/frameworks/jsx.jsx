import React, {Component} from "react";

class Hello extends Component {
  constructor (props) {
    super(props);

    this.state = {
      hello: this.helllo.bind(this),
    };
  }

  componentDidMount() {
    console.log("~~~ componentDidMount");
  }

  componentDidUpdate() {
    console.log("~~~ componentDidUpdate");
  }

  hello() {
    console.log(">>> call hello...");

    return(<div>
      <p> Hello, world! </p>
    </div>);
  }

  render() {
    return (<>
      {this.hello()}
    </>)
  }
}

export default Hello;
