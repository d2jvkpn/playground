import { userUpdate } from "js/api.js";

class Elem extends Component {
  constructor (props) {
    super(props);

    this.state = {
      item: { avatar: "", ...this.props.item },
      image: { file: null, ext: "" },
    };
  }

  handleSubmit = () => {
    if (!this.state.image.file) {
      this.updateUser();
      return;
    }

    let key = `static/avatar/` +
      `${this.state.item.userId}_xxxxxxxx.${this.state.image.ext}`;

    putObject("avatar", key, this.state.image.file, link => {
      if (!link) {
        return;
      }
      let item = {...this.state.item};
      item.avatar = link;
      this.setState({item: item}, this.updateUser);
    });
  }

  updateUser = () => {
    // TODO:...

    let data = this.state.item;

    userUpdate(data, res => {
      if (res.code === 0) {
        message.info("success.");
        this.props.updateItem(data);
      } else {
        message.error("failed to update!");
      }
    });
  }

  render() {
    return(<>
      ....
    </>)
  }
}

export default Elem;
