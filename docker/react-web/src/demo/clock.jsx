import React, {Component} from "react";

import { datetime } from "js/utils.js";

class Clock extends Component {
  constructor (props) {
    super(props);

    this.state = {
      at: datetime().rfc3339ms,
      count: 0,
      // list: this.props.list.map(v => ({...v})),
    };
  }

  componentDidMount() {}
  componentDidUpdate() {}

  updateNow = () => {
    this.setState({at: datetime().rfc3339}); // datetime().rfc3339ms
  }

  render() {
    setInterval(this.updateNow, this.props.duration || 1000);

    return (<>
      <p style={{cursor:"pointer"}} title="Click to increase"
        onClick={() => {
          let count = this.state.count;
          this.setState({count: count + 1});
        }}
      >
        {this.state.count}
      </p>

      <p> {this.state.at} </p>

      {/*
      <Elem
        item={this.state.item}
        updateItem = { (kv) => {
          let item = {...this.state.item, ...kv};
          this.setState({item: item});
        }}
      />
      */}
    </>);
  }
}

export default Clock;
