import stores from "./stores"
import utils from "./utils"
import { hey } from "./utils/hello.js"
import hello from "./utils/hello.js"

stores.setAccount({id: 123})
utils.hey()

hey()
hello.world()
